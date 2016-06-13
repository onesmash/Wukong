local Class = require('Class')
local Renderer = require('Renderer')

local modName = ...

local UIRenderer = Class(modName, Renderer, false)

_G[modName] = UIRenderer
package.loaded[modName] = UIRenderer

local print = print
local math = math

_ENV = UIRenderer

function init(self, sortingLayer, sortingOrder)
	super.init(self)
end

function setCanvas(self, canvas)
	self.canvas = canvas
end

function render(self)
	self.canvas:display()
	local width = self.canvas.width
	local height = self.canvas.height
	local position = self.transform:getPosition()
	local screenPosition = self.entity:getScene():getMainCamera():worldToScreenPoint(position.x, position.y)
	local originX = screenPosition.x - width * self.canvas.center.x
	local originY = screenPosition.y - height * (1 - self.canvas.center.y)
	local dstRect = {x = originX, y = originY, w = width, h = height}
	local srcRect = {x = 0, y = 0, w = width, h = height}
	self:draw(self.canvas.texture, srcRect, dstRect, -math.deg(self.transform:getLocalRotation()), 
		{x = width * self.canvas.center.x, y = height * (1 - self.canvas.center.y)})
	
	--[[
	local aabb = self.entity:getScene():getBroadPhase():getFatAABB(self.entity._proxyId);
	if aabb then
		local lowerBound = self.entity:getScene():getMainCamera():worldToScreenPoint(aabb.lowerBound.x, aabb.lowerBound.y)
		local upperBound = self.entity:getScene():getMainCamera():worldToScreenPoint(aabb.upperBound.x, aabb.upperBound.y)

		local height = lowerBound.y - upperBound.y
		local width = upperBound.x - lowerBound.x
		self:drawRect({r = 100, g = 100, b = 100, a = 255}, {x = lowerBound.x, y = lowerBound.y - height, w = width, h = height})
	end
	]]--
	
end