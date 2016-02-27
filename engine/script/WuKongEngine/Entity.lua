local Class = require('Class')
local GameObject = require('GameObject')

local modName = ...

local Entity = Class(modName, GameObject, false)

_G[modName] = Entity
package.loaded[modName] = Entity

local string = string

local _ENV = Entity

local firstCharacterLowercase = function(str)
	return string.gsub(str, '^%u', string.lower)
end

function init(self)
	self = super.init(self)
	self.components = {}
end

function addComponent(self, componentClass)
	local component = componentClass()
	local componentName = firstCharacterLowercase(componentClass.className)
	self.components[componentName] = component
	component.entity = self
	component.transform = self.components.transform
end