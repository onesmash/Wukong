local Class = require('Class')
local Entity = require('Entity')
local UIRenderer = require('UIRenderer')
local UIBehaviour = require('UIBehaviour')
local Canvas = require('Canvas')

local modName = ...

local UIView = Class(modName, Entity, false)

_G[modName] = UIView
package.loaded[modName] = UIView

local print = print

local _ENV = UIView

function init(self, width, height, centerX, centerY)
	super.init(self)
	self:addComponent(UIBehaviour)
	local renderer = self:addComponent(UIRenderer)
	local canvas = Canvas()
	canvas.delegate = self
	canvas.center = {x = centerX, y = centerY}
	canvas.width = width
	canvas.height = height
	renderer:setCanvas(canvas)
	self._canvas = canvas
	self.needDisplay = true
end

function setWorldSpace(self, worldSpace)
	self._canvas:setWorldSpace(worldSpace)
end

function setNeedDisplay(self)
	self.needDisplay = true
end

function clearNeedDisplay(self)
	self.needDisplay = false
end

function display(self, canvas)
	-- body
end

function setScene(self, scene)
	self:enumerate(function(view)
		view._scene = scene
		return true
	end)
end

function addSubview(self, subview)
	if subview:isKindOf(UIView) then
		self:addChild(subview)
	end
end