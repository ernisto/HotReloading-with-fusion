--!strict
--!nolint LocalUnused
--!nolint LocalShadow
local Fusion = require(game.ReplicatedStorage.Packages.Fusion)
local parseError = require(game.ReplicatedStorage.Shared.parseError)
local For = require(script.Parent.For)

local Computed = Fusion.Computed
local doCleanup = Fusion.doCleanup

local function ForKeys<KI, KO, V, S, a>(
	scope: S,
	inputTable: Fusion.UsedAs<{[KI]: V}>,
	processor: (Fusion.Use, S & a, KI) -> KO
): Fusion.For<KO, V>
	if typeof(inputTable) == "function" then
		error( "scope missing - myScope:ForKeys(inputTable, function(scope, use, key) ... end)")
	end
	local self
	self = For(
		scope :: any,
		inputTable,
		function(
			scope: Fusion.Scope<S>,
			inputPair: Fusion.StateObject<{key: KI, value: V}>
		)
			local inputKey = Computed(scope, function(use, scope): KI
				return use(inputPair).key
			end)
			local outputKey = Computed(scope, function(use, scope): KO?
				local ok, key = xpcall(if self then (self :: any)._innerProcessor else processor, parseError, use, scope, use(inputKey))
				if ok then return key end
				
				local err = key :: any
				task.spawn(error, `{err.message}\n{err.trace}`)
				
				doCleanup(scope)
				table.clear(scope)
				return
			end)
			return Computed(scope, function(use, scope)
				return {key = use(outputKey), value = use(inputPair).value}
			end)
		end
	)
	;(self :: any)._innerProcessor = processor
	return self
end

return ForKeys