local Class = require('Class')
local Renderer = require('Renderer')

local modName = ...

local SpriteRenderer = Class(modName, Renderer, false)

_G[modName] = SpriteRenderer
package.loaded[modName] = SpriteRenderer

local print = print
local math = math

local _ENV = SpriteRenderer

function init(self, sprite, sortingLayer, sortingOrder)
	super.init(self, sortingLayer, sortingOrder)
	self.sprite = sprite
end

function render(self)
	--print('render')
	local width = self.sprite.width
	local height = self.sprite.height
	local position = self.transform:getPosition()
	local screenPosition = self.entity:getScene():getMainCamera():worldToScreenPoint(position.x, position.y)
	local originX = math.ceil(screenPosition.x - width * self.sprite.center.x)
	local originY = math.ceil(screenPosition.y - height * (1 - self.sprite.center.y))
	local dstRect = {x = originX, y = originY, w = width, h = height}
	self:draw(self.sprite.texture, self.sprite.rect, dstRect, math.deg(-self.transform:getLocalRotation()), 
		{x = math.ceil(width * self.sprite.center.x), y = math.ceil(height * (1 - self.sprite.center.y))})
end