local Class = require('Class')
local Component = require('Component')
local Collider = require('Collider')

local modName = ...

local BoxCollider = Class(modName, Collider, false)

_G[modName] = BoxCollider
package.loaded[modName] = BoxCollider

_ENV = BoxCollider

function init(self)
	super.init(self)
end