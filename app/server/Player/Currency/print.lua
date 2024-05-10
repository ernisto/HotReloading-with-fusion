local World = require(game.ReplicatedStorage.World):Module(script)
local Currency = require(script.Parent)

return World('r'):ForPairs(Currency, function(use, scope, player, currency)

    warn('display Currency', currency, 'for', player)
    scope('ta'):Computed(function(use) print('currency.amount =', player, use(currency.amount)) end)

    return player, scope
end)