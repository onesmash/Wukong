local Class = require('Class')
local Renderer = require('Renderer')
local AABB = require('AABB')

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
	--print('draw ', self.entity.className)
	local width = self.sprite.width
	local height = self.sprite.height
	local position = self.transform:getPosition()
	local screenPosition = self.entity:getScene():getMainCamera():worldToScreenPoint(position.x, position.y)
	local originX = screenPosition.x - width * self.sprite.center.x
	local originY = screenPosition.y - height * (1 - self.sprite.center.y)
	local dstRect = {x = originX, y = originY, w = width, h = height}
	self:draw(self.sprite.texture, self.sprite.rect, dstRect, -math.deg(self.transform:getLocalRotation()), 
		{x = width * self.sprite.center.x, y = height * (1 - self.sprite.center.y)})
	
	
	local aabb = self.entity:getScene():getBroadPhase():getFatAABB(self.entity._proxyId);
	if aabb then
		local lowerBound = self.entity:getScene():getMainCamera():worldToScreenPoint(aabb.lowerBound.x, aabb.lowerBound.y)
		local upperBound = self.entity:getScene():getMainCamera():worldToScreenPoint(aabb.upperBound.x, aabb.upperBound.y)

		local height = lowerBound.y - upperBound.y
		local width = upperBound.x - lowerBound.x
		self:drawRect({r = 100, g = 100, b = 100, a = 255}, {x = lowerBound.x, y = lowerBound.y - height, w = width, h = height})
	end
	
	
end