local Class = require('Class')
local Object = require('Object')

local modName = ...

local Touch = Class(modName, Object, false)

_G[modName] = Touch
package.loaded[modName] = Touch

local print = print

local _ENV = Touch

Began = 0
moved = 1
Stationary = 2
End = 3

function init(self)
	self.phase = Touch.End
	self.selectedEntity = nil
	self.touchId = -1
	self.deltaPosition = {x = 0, y = 0}
end