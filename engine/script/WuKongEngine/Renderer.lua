local Class = require('Class')
local Component = require('Component')
local Runtime = require('runtime')
local RenderService = require('RenderService')

local modName = ...

local Renderer = Class(modName, Component, false)

_G[modName] = Renderer
package.loaded[modName] = Renderer

local print = print
local math = math
local renderer = Runtime._renderer

local _ENV = Renderer

sortingLayer = {GUILayer = 0, defaultLayer = 100}
sortingOrder = {defalutOrder = 0}

platformRenderer = Runtime._renderer

function clear(color)
 	--renderer:setDrawColor(color)
	--renderer:clear()
	local renderService = Runtime.getService(RenderService)
	renderService:clear(color)
end

function present()
	--renderer:present()
	local renderService = Runtime.getService(RenderService)
	renderService:present()
end

function renderBegin()
	local renderService = Runtime.getService(RenderService)
	renderService:renderBegin()
end

function renderEnd()
	local renderService = Runtime.getService(RenderService)
	renderService:renderEnd()
end

function init(self, sortingLayer, sortingOrder)
	super.init(self)
	self.sortingLayer = sortingLayer or Renderer.sortingLayer.defaultLayer
	self.sortingOrder = sortingOrder or Renderer.sortingOrder.defalutOrder
	self.isVisible = true
end

function setVisible(self, visible)
	if self.entity:getScene() then
		self.entity:getScene():setNeedSortRenderOrder()
	end
end

function render(self)
	
end

function drawRect(self, color, rect)
	local renderService = Runtime.getService(RenderService)
	renderService:drawRect(color, rect)
end

function draw(self, texture, srcRect, dstRect, angle, center)
	local renderService = Runtime.getService(RenderService)
	renderService:draw(texture, srcRect, dstRect, angle, center)
	
	--[[
	if not angle then
		renderer:copy(texture._sdltexture, srcRect, dstRect)
	else
		local params = {texture = texture._sdltexture, source = srcRect, destination = dstRect, angle = angle, center = center}
		renderer:copyEx(params)
	end
	]]--
	
end