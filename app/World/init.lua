--!strict

--// Packages
local Fusion = require(game.ReplicatedStorage.Packages.Fusion)
local Instance = require(script.Instance)
local Scopes = require(script.Scopes)
local Module = require(script.Module)
local Table = require(script.Table)
local Task = require(script.Task)

local reloadable = require(script.reloadable)

--// Module
local self = {
    Attribute = Fusion.Attribute,
    Children = Fusion.Children,
    Computed = Fusion.Computed,
    Contextual = Fusion.Contextual,
    Hydrate = Fusion.Hydrate,
    New = Fusion.New,
    Observer = Fusion.Observer,
    Ref = Fusion.Ref,
    Spring = Fusion.Spring,
    Tween = Fusion.Tween,
    Value = Fusion.Value,
    deriveScope = Fusion.deriveScope,
    doCleanup = Fusion.doCleanup,
    peek = Fusion.peek,
    scoped = Fusion.scoped,
    version = Fusion.version,
    AttributeChange = Fusion.AttributeChange,
    AttributeOut = Fusion.AttributeOut,
    OnChange = Fusion.OnChange,
    OnEvent = Fusion.OnEvent,
    Out = Fusion.Out,

    innerScope = Scopes.innerScope,
    Module = Module.Module,

    Delay = Task.Delay,
    Sleep = Task.Sleep,
    Spawn = Task.Spawn,

    Table = Table.Table,
    ForKeys = Table.ForKeys,
    ForPairs = Table.ForPairs,
    ForValues = Table.ForValues,

    watchDescendants = Instance.watchDescendants,
    watchChildren = Instance.watchChildren,
    watchAttrs = Instance.watchAttrs,
    watchAttr = Instance.watchAttr,
    watchProp = Instance.watchProp
}
self.__call = reloadable
self.__index = self

return setmetatable(self, { __call = reloadable })