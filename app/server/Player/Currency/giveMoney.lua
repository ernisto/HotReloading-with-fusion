--!strict
local World = require(game.ReplicatedStorage.World):Module(script)
local Currency = require(script.Parent)

return World('r'):ForPairs(Currency, function(use, scope, player, currency)
    
    warn('giving Currency', currency, 'for', player)

    scope('giver'):Spawn(function()
        while task.wait(.5) do currency.amount:set(currency.amount._value + 1) end
    end)
    return player, scope
end)