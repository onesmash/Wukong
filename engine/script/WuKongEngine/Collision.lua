local Class = require('Class')
local GameObject = require('GameObject')

local modName = ...

local Collision = Class(modName, GameObject, false)

_G[modName] = Collision
package.loaded[modName] = Collision

local _ENV = Collision

function init(self, collider)
	super.init(self)
	self.collider = collider
end
