local Class = require('Class')
local GameObject = require('GameObject')
local Renderer = require('Renderer')
local Texture = require('Texture')
local CCanvas = require('runtime.Canvas.c')

local modName = ...

local Canvas = Class(modName, GameObject, false)

_G[modName] = Canvas
package.loaded[modName] = Canvas

local print = print

local _ENV = Canvas

function new(class)
	return CCanvas.new(class)
end

function init(self, width, height)
	super.init(self)
	self.center = {x = 0.5, y = 0.5}
	self.width = width
	self.height = height
	self.worldSpace = false
	self.delegate = nil
end

function setWorldSpace(self, worldSpace)
	self.worldSpace = worldSpace
end

function display(self)
	self:beginDisplay()
	self.delegate:display(self)
	self:endDisplay()
end

function drawText(self, text, font, color)
	CCanvas.drawText(self, text, font, color)
end

function beginDisplay(self)
	-- body
end

function endDisplay(self)
	local texture = Texture()
	texture:loadCanvas(self)
	self.texture = texture
end