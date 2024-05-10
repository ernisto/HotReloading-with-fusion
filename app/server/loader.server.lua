local Rewire = require(game.ReplicatedStorage.Packages.Rewire)

Rewire.HotReloader.new():scan(game.ServerScriptService,
    require,
    function(module)  end
)