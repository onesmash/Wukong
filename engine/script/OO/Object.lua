local Class = require('Class')

local modName = ...

local Object = {}

setmetatable(Object, Class)

_G[modName] = Object
package.loaded[modName] = Object

local print = print
local rawget = rawget

local _ENV = Object

className = modName

isa = Class

private = {}
___privates = {}
___privates[modName] = {}

function init(self, ...)
end

function isMemberOf(self, class)
	return self.isa == class
end

function isKindOf(self, class)
	local clz = self.isa
	while clz do
		if clz == class then
			return true
		else
			clz = rawget(clz, '___superClass')
		end
	end
	return false
end