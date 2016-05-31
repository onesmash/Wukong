local Class = require('Class')
local UIView = require('UIView')
local UILabelBehaviour = require('UILabelBehaviour')
local Texture = require('Texture')

local modName = ...

local UILabel = Class(modName, UIView, false)

_G[modName] = UILabel
package.loaded[modName] = UILabel

local print = print

local _ENV = UILabel

function init(self, width, height, centerX, centerY)
	super.init(self, width, height, centerY, centerY)
	self:addComponent(UILabelBehaviour)
end

function setFont(self, font)
	self.font = font
	self:setNeedDisplay()
end

function setTextColor(self, r, g, b, a)
	self.color = {r = r, g = g, b = b, a = a}
	self:setNeedDisplay()
end

function  setText(self, text)
	self.text = text
	self:setNeedDisplay()
end

function display(self, canvas)
	if self.needDisplay then
		canvas:drawText(self.text, self.font, self.color)
	end
	self:clearNeedDisplay()
end