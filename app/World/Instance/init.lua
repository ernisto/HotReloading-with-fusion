--// Packages
local Fusion = require(game.ReplicatedStorage.Packages.Fusion)
local Table = require(script.Parent.Table)
type Table<i, v> = Table.TableValue<i, v>
local Table = Table.Table

--// Module
local function watchChildren(
	scope: Fusion.Scope<typeof(Fusion)>,
	target: Instance
): Table<number, Instance>
	local children = Table(scope)
	local function updateChildren() children:set(target:GetChildren()) end

	table.insert(scope, target.ChildRemoved:Connect(updateChildren))
	table.insert(scope, target.ChildAdded:Connect(updateChildren))
	updateChildren()

	return children
end

local function watchDescendants(
	scope: Fusion.Scope<typeof(Fusion)>,
	target: Instance
): Table<number, Instance>
	local descendants = Table(scope)
	local function updateDescendants() descendants:set(target:GetDescendants()) end

	table.insert(scope, target.DescendantRemoving:Connect(updateDescendants))
	table.insert(scope, target.DescendantAdded:Connect(updateDescendants))
	updateDescendants()

	return descendants
end

local function watchAttrs(
	scope: Fusion.Scope<typeof(Fusion)>,
	target: Instance
): Table<string, any>
	local attributes = scope:Value({})
	local function updateAttributes() attributes:set(target:GetAttributes()) end

	table.insert(scope, target.AttributeChanged:Connect(updateAttributes))
	updateAttributes()

	return attributes
end
local function watchAttr(
	scope: Fusion.Scope<typeof(Fusion)>,
	target: Instance,
	name: string
)
	local attribute = scope:Value(nil :: any)
	Fusion:Hydrate(target) { [Fusion.AttributeOut(name)] = attribute }

	return attribute
end
local function watchProp(
	scope: Fusion.Scope<typeof(Fusion)>,
	target: Instance,
	name: string
)
	local property = scope:Value(nil :: any)
	Fusion:Hydrate(target) { [Fusion.Out(name)] = property }

	return property
end
return {
    watchChildren = watchChildren,
    watchDescendants = watchDescendants,
    
    watchAttr = watchAttr,
    watchAttrs = watchAttrs,
    
    watchProp = watchProp
}