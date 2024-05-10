--// Packages
local Fusion = require(game.ReplicatedStorage.Packages.Fusion)

--// Functions
local reloaders = {
    New = function(instance, props)
        Fusion:Hydrate(instance)(props)
    end,
    Hydrate = function(instance, props)
        Fusion:Hydrate(instance)(props)
    end,
    Value = function(component, value)
        if not component._isDefault then return end
        component._value = value
    end,
    Computed = function(component, processor)
        component._processor = processor
        component:update()
    end,
    ForPairs = function(component, table, processor)
        component._innerProcessor = processor
        for computed in component._existingProcessors or {} do computed.outputPair:update() end
    end,
    ForValues = function(component, table, processor)
        component._innerProcessor = processor
        for computed in component._existingProcessors or {} do computed.outputPair:update() end
    end,
    ForKeys = function(component, table, processor)
        component._innerProcessor = processor
        for computed in component._existingProcessors or {} do computed.outputPair:update() end
    end,
}

--// Module
local function reloadable<s, id>(_scope: s, id: id & string): s & Fusion.Scope<s> & { [string]: unknown }
    local scope = _scope :: any
    return setmetatable({}, { __index = function(_,index)
        local reloader = reloaders[index]
        return function(_,...)
            local component = scope[id]
            if component and reloader then

                reloader(component,...)
            else
                Fusion.doCleanup(component)
                
                component = scope[index](scope,...)
                scope[id] = component

                if index == 'Value' then
                    component._isDefault = true
                    
                    local observer = scope:Observer(component)
                    observer:onChange(function() component._isDefault = false; observer:destroy() end)
                end
            end
            return component
        end
    end}) :: any
end
return reloadable