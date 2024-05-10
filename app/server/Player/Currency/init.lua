local World = require(game.ReplicatedStorage.World):Module(script)
local Players = require(game.ReplicatedStorage.Shared.Player)

return World:ForPairs(Players, function(use, scope, player)

    scope.amount = scope:Value(1)

    function scope:expect(amount: number, message: string?)
        assert(self.amount._value >= amount, message or `not enough money`) end

    return player, scope
end)