local World = require(game.ReplicatedStorage.World):Module(script)
local Currency = require(script.Parent)

return World('r'):ForPairs(Currency, function(use, scope, player, currency)

    return player, scope('a'):New('Folder') {
        Name = 'currency', Parent = player,
        [World.Attribute 'amount'] = scope('b'):Computed(function(use)
            
            return `money: {use(currency.amount)}.....`
        end)
    }
end)