--!strict
--!nolint LocalUnused
--!nolint LocalShadow
--[[
	Constructs a new For object which maps values of a table using a `processor`
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

local function ForValues<K, VI, VO, S, a>(
	scope: S,
	inputTable: Fusion.UsedAs<{[K]: VI}>,
	processor: (Fusion.Use, S & a, VI) -> VO
): Fusion.For<K, VO>
	if typeof(inputTable) == "function" then
		error("scopeMissing - myScope:ForValues(inputTable, function(scope, use, value) ... end)")
	end
	local self: any
	self = For(
		scope :: any,
		inputTable,
		function(
			scope: Fusion.Scope<S>,
			inputPair: Fusion.StateObject<{key: K, value: VI}>
		)
			local inputValue = Computed(scope, function(use, scope): VI
				return use(inputPair).value
			end)
			return Computed(scope, function(use, scope): {key: nil, value: VO?}

				local r = table.pack(xpcall(if self then (self :: any)._innerProcessor else processor, parseError, use, scope, use(inputValue)))
				if r[1] then return {key = nil, value = if r.n >= 2 then r[2] else use(inputValue) } end

				local err = r[2] :: any
				task.spawn(error, `{err.message}\n{err.trace}`)

				doCleanup(scope)
				table.clear(scope)

				return {key = nil, value = nil}
			end)
		end
	)
	;(self :: any)._innerProcessor = processor
	return self
end

return ForValues