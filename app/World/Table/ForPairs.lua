--!strict
--!nolint LocalUnused
--!nolint LocalShadow
--[[
	Constructs a new For object which maps pairs of a table using a `processor`
	function.

	Optionally, a `destructor` function can be specified for cleaning up output.

	Additionally, a `meta` table/value can optionally be returned to pass data
	created when running the processor to the destructor when the created object
	is cleaned up.
]]
local Fusion = require(game.ReplicatedStorage.Packages.Fusion)
local parseError = require(game.ReplicatedStorage.Shared.parseError)
local For = require(script.Parent.For)

local Computed = Fusion.Computed
local doCleanup = Fusion.doCleanup

local function ForPairs<KI, KO, VI, VO, S, a>(
	scope: S,
	inputTable: Fusion.UsedAs<{[KI]: VI}>,
	processor: (Fusion.Use, S & a, KI, VI) -> (KO, VO)
): Fusion.For<KO, VO>
	if typeof(inputTable) == "function" then
		error("scopeMissing - myScope:ForPairs(inputTable, function(scope, use, key, value) ... end)")
	end
	local self
	self = For(
		scope :: any,
		inputTable,
		function(
			scope: Fusion.Scope<S>,
			inputPair: Fusion.StateObject<{key: KI, value: VI}>
		)
			return Computed(scope, function(use, scope): {key: KO?, value: VO?}

				local pair = use(inputPair)
				local r = table.pack(xpcall(if self then (self :: any)._innerProcessor else processor, parseError, use, scope, pair.key, pair.value))

				if r[1] then return {
					key = if r.n >= 2 then r[2] else pair.key,
					value = if r.n >= 3 then r[3] else pair.value
				} end

				local err = r[2]
				task.spawn(error, `{err.message}\n{err.trace}`)

				doCleanup(scope)
				table.clear(scope)

				return { key = nil, value = nil }
			end)
		end
	)
	;(self :: any)._innerProcessor = processor
	return self :: Fusion.For<KO, VO>
end

return ForPairs