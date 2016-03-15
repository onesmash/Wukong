local Class = require('Class')
local Component = require('Component')
local runtime = require('runtime')

local modName = ...

local Renderer = Class(modName, Component, false)

_G[modName] = Renderer
package.loaded[modName] = Renderer

local print = print
local math = math

local renderer = runtime._renderer

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

function init(self, sprite, sortingLayer, sortingOrder)
	super.init(self)
	self.sprite = sprite
	self.sortingLayer = sortingLayer or Renderer.sortingLayer.defaultLayer
	self.sortingOrder = sortingOrder or Renderer.sortingOrder.defalutOrder
	self.isVisible = true
end

function setVisible(self, visible)
	if self.entity.scene then
		self.entity.scene:setNeedSortRenderOrder()
	end
end

function render(self)
	--print('render')
	local width = self.sprite.width
	local height = self.sprite.height
	local originX = self.transform.position.x - math.floor(width * self.sprite.center.x)
	local originY = self.transform.position.y - math.floor(height * self.sprite.center.y)
	local dstRect = {x = originX, y = originY, w = width, h = height}
	--print(originX)
	--print(originY)
	renderer:copy(self.sprite.texture._sdltexture, self.sprite.rect, dstRect)
end