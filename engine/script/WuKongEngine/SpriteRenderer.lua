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
	local originX = math.ceil(position.x - width * self.sprite.center.x)
	local originY = math.ceil(position.y - height * self.sprite.center.y)
	local dstRect = {x = originX, y = originY, w = width, h = height}
	self:draw(self.sprite.texture, self.sprite.rect, dstRect, self.transform:getLocalRotation() * 180 / math.pi, 
		{x = math.ceil(width * self.sprite.center.x), y = math.ceil(height * self.sprite.center.y)})
end