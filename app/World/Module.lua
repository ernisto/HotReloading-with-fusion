local Fusion = require(game.ReplicatedStorage.Packages.Fusion)

local scopes = {}
local function Module<parentScope>(parent: parentScope, baseModule: ModuleScript): parentScope

    local moduleId = baseModule:GetFullName()
    if scopes[moduleId] then return scopes[moduleId] end

    local scope = Fusion.deriveScope(parent, { instance = baseModule, moduleId = moduleId })
    scopes[moduleId] = scope

    return scope
end

return { Module = Module }