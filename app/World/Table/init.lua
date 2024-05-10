local Fusion = require(game.ReplicatedStorage.Packages.Fusion)

local ForValues = require(script.ForValues)
local ForPairs = require(script.ForPairs)
local ForKeys = require(script.ForKeys)

export type TableValue<key, value> = Fusion.Value<{ [key]: value }, { [key]: value }> & {
	state: (any, key: key) -> Fusion.Value<value, value>,
	expect: (any, key: key) -> value,
	await: (any, key: key) -> value,
	find: (any, key: key) -> value?,
}
export type mutTableValue<key, value> = TableValue<key, value> & {
	setKey: (any, key: key, value: value) -> (),
	set: (any, { [key]: value }) -> (),
}

local function Table<scope, key, value>(
	scope,
	default: { [key]: value }?
): TableValue<key, value>
	local states = {}
	local values = default or {} :: { [key]: value }
	
	local state = scope:Value(values)
	local setAll = state.set

	function state:set(_values)
		
		values = _values
		setAll(state, _values)
		
		for index, state in states do state:set(_values[index]) end
	end
	function state:setKey(key: key, value: value?)
		values[key] = value
		state:set(values)
		--if states[key] then states[key]:set(value) end stranger crash
	end

	function state:state(key: key)
		local state = states[key]
		if not state then
			state = scope:Value(values[key])
			states[key] = state
		end
		return state
	end
	function state:await(key)
		while not values[key] do task.wait() end
		return values[key]
	end

	function state:expect(key: key, message: string) return values[key] or error(message or `key({key}) doesnt exists`) end
	function state:find(key: key) return values[key] end
	return state
end
return { Table = Table, ForValues = ForValues, ForPairs = ForPairs, ForKeys = ForKeys }