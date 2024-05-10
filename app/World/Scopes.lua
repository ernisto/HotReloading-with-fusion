local function innerScope<T, fields>(
	parent: T,
	fields: fields?
): T & fields
	local self = setmetatable(
		fields :: any or {},
		parent
	) :: any
	self.__index = self
	self.__call = (parent :: any).__call
	return self
end
return { innerScope = innerScope }