local Class = require('Class')
local GameObject = require('GameObject')

local modName = ...

local Component = Class(modName, GameObject, false)

_G[modName] = Component
package.loaded[modName] = Component

local _ENV = Component

function init(self)
	super.init(self)
end