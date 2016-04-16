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

static.sortingLayer = {GUILayer = 0, defaultLayer = 100}
static.sortingOrder = {defalutOrder = 0}

function static.clear(color)
 	--renderer:setDrawColor(color)
	--renderer:clear()
	local renderService = Runtime.getService(RenderService)
	renderService:clear(color)
end

function static.present()
	--renderer:present()
	local renderService = Runtime.getService(RenderService)
	renderService:present()
end

function static.renderBegin()
	local renderService = Runtime.getService(RenderService)
	renderService:renderBegin()
end

function static.renderEnd()
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
	--renderer:setDrawColor(color)
	--renderer:drawRect(rect)
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