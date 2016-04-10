local Class = require('Class')
local Component = require('Component')

local modName = ...

local Collider = Class(modName, Component, false)

_G[modName] = Collider
package.loaded[modName] = Collider

_ENV = Collider

function init(self)
	super.init(self)
	self.center = {x = 0.5, y = 0.5}
	self.width = 0
	self.height = 0
end