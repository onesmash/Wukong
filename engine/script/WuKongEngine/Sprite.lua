local Class = require('Class')
local GameObject = require('GameObject')

local modName = ...

local Sprite = Class(modName, GameObject, false)

_G[modName] = Sprite
package.loaded[modName] = Sprite

local _ENV = Sprite

function init(self, texture, rect)
	super.init(self)
	self.texture = texture
	self.rect = rect
	self.center = {x = 0.5, y = 0.5}
	self.width = rect and rect.w or 0
	self.height = rect and rect.h or 0
end