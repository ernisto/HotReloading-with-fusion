local Rewire = require(game.ReplicatedStorage.Packages.Rewire)

Rewire.HotReloader.new():scan(game.ReplicatedStorage.Client,
    require,
    function(module)  end
)