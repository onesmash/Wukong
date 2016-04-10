local Class = require('Class')
local Object = require('Object')

local modName = ...

local Touch = Class(modName, Object, false)

_G[modName] = Touch
package.loaded[modName] = Touch

local print = print

local _ENV = Touch

static.Began = 0
static.move = 1
static.Stationary = 2
static.End = 3

function init(self)
	self.phase = Touch.End
	self.selectedEntity = nil
	self.touchId = -1
end