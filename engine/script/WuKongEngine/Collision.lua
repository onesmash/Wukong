local Class = require('Class')
local Object = require('Object')

local modName = ...

local Collision = Class(modName, Object, false)

_G[modName] = Collision
package.loaded[modName] = Collision

local _ENV = Collision

function init(self, collider)
	super.init(self)
	self.collider = collider
end
