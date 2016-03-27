local Class = require('Class')
local GameObject = require('GameObject')
--local Behaviour = require('Behaviour')

local modName = ...

local Component = Class(modName, GameObject, false)

_G[modName] = Component
package.loaded[modName] = Component

local _ENV = Component

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