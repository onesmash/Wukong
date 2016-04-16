local Class = require('Class')
local Component = require('Component')
local Vector3 = require('Vector3')

local modName = ...

local Collider = Class(modName, Component, false)

_G[modName] = Collider
package.loaded[modName] = Collider

local print = print

_ENV = Collider

function init(self)
	super.init(self)
	self.enabled = true
	self.center = {x = 0.5, y = 0.5}
	self.width = 0
	self.height = 0
end

function testCollide(self, collider)
	return false
end