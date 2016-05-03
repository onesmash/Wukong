local Class = require('Class')
local GameObject = require('GameObject')
--local Behaviour = require('Behaviour')

local modName = ...

local Component = Class(modName, GameObject, false)

_G[modName] = Component
package.loaded[modName] = Component

local string = string
local print = print

local _ENV = Component

local function firstCharacterLowercase(str)
	return string.gsub(str, '^%u', string.lower)
end

function getComponentName(class)
	if not class._componentName then
		class._componentName = firstCharacterLowercase(class.className)
	end
	return class._componentName
end

function init(self)
	super.init(self)
end

function setEntity(self, entity)
	self.entity = entity
end

function setTransform(self, transform)
	self.transform = transform
end

--[[
function sendMessage(self, methodName, ...)
	local behaviour = self.entity:getComponent(Behaviour)
	local params = ...
	if behaviour then
		behaviour[methodName](behaviour, params)
	end
end

function broadcastMessage(self, methodName, ...)
	local params = ...
	self.entity:enumerate(function(entity)
		entity:sendMessage(methodName, params)
		return true
	end)
end
]]--