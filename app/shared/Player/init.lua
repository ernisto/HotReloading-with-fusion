local World = require(game.ReplicatedStorage.World):Module(script)
local Fusion = require(game.ReplicatedStorage.Packages.Fusion)

return World:ForPairs(World:watchChildren(game.Players), function(use, scope, _, player)

    if not player:IsA('Player') then return end
    return player, player
end) :: Fusion.For<Player, Player>