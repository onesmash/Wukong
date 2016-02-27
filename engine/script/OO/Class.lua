local modName = ...

local Class = {}
local Class_mt = {__call = function(t, ...)
	return t.subclass(...)
end}
setmetatable(Class, Class_mt)

local originalType = type

type = function(x)
	return (originalType(x) == 'table' and x.isa and 'object') or originalType(x)
end

local  print = print

_G[modName] = Class
package.loaded[modName] = Class

local setmetatable = setmetatable 
local pairs = pairs
local type = type
local rawget = rawget

local _ENV = Class

__call = function(class, ...)
	local self = {}
	setmetatable(self, class)
	self.isa = class
	self.___privates = {}
	for className, privates in pairs(class.___privates) do
		local private = {}
		for k, v in pairs(privates) do
			private[k] = v
		end
		self.___privates[className] = private
	end
	self:init(...)
	return self
end

__index = function(class, key)
	local cache = class.___staticCache
	local x = cache[key]
	if x == nil then
		local clz = class
		repeat
			x = clz.static[key]
			clz = rawget(clz, '___superClass')
		until x ~= nil or clz == nil
		cache[key] = x
	end
	return x
end

function subclass(className, superClass, hasFinalizer)
	local class = {}
	class.isa = Class
	class.className = className
	class.___superClass = superClass
	class.super = superClass
	class.private = {}
	class.___privates = {}
	class.___privates[className] = {}
	for className, privates in pairs(superClass.___privates) do
		local private = {}
		for k, v in pairs(privates) do
			private[k] = v
		end
		class.___privates[className] = private
	end
	setmetatable(class.private, {__call = function(t, self, ...)
		return self.___privates[className]
	end, __newindex = function(private, k, v)
		class.___privates[className][k] = v
	end})
	class.static = {}
	class.___staticCache = {}
	setmetatable(class.___staticCache, {__mode = 'v'})
	class.___publicCache = {}
	setmetatable(class.___publicCache, {__mode = 'v'})
	class.__index = function(t, key)
		local cache = class.___publicCache
		local x = cache[key]
		if x == nil then
			local clz = class
			repeat
				x = rawget(clz, key)
				clz = rawget(clz, '___superClass')
			until x ~= nil or clz == nil
			cache[key] = x
		end
		return x
	end
	if hasFinalizer then
		class.finalize = function(...)
			-- body
		end
		class.__gc = function(...)
			return class.finalize(...)
		end
	end
	return setmetatable(class, Class)
end