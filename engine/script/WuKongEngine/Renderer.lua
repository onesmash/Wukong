local Class = require('Class')
local Component = require('Component')
local Runtime = require('runtime')

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
 	renderer:setDrawColor(color)
	renderer:clear()
end

function static.present()
	renderer:present()
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
	--print('render')
end

function draw(self, texture, srcRect, dstRect, angle, center)
	if not angle then
		renderer:copy(texture._sdltexture, srcRect, dstRect)
	else
		local params = {texture = texture._sdltexture, source = srcRect, destination = dstRect, angle = angle, center = center}
		renderer:copyEx(params)
	end
	
end