local Class = require('Class')
local Component = require('Component')

local modName = ...

local Transform = Class(modName, Component, false)

_G[modName] = Transform
package.loaded[modName] = Transform

local _ENV = Transform

function init(self)
	super.init(self)
	self.position = {x = 0, y = 0}
	self.localPosition = {x = 0, y = 0}
	self.localScale = {x = 1, y = 1}
	self.localRotation = {x = 0, y = 0}
end

function setParent(self, transform)
	self._parent = transform
	self.localPosition.x = self.position.x - transform.position.x
	self.localPosition.y = self.position.y - transform.position.y
end