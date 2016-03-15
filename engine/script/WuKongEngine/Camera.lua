local Class = require('Class')
local Component = require('Component')
local Runtime = require('runtime')

local modName = ...

local Camera = Class(modName, Component, false)

_G[modName] = Camera
package.loaded[modName] = Camera

local print = print

local _ENV = Camera

function init(self)
	super.init(self)
	self.pixelWidth = Runtime.Device.displayInfo.w
	self.pixelHeight = Runtime.Device.displayInfo.h
	self.rect = {x = 0, y = 0, w = 1, h = 1}
	self.needClear = false
	self.backgroundColor = {r = 255, g = 255, b = 255, a = 255}
end

function isVisibleByMe(self, entity)
	return true
end

function addPreRenderDelegate(self, delegate)
	
end

function addPostRenderDelegate(self, delegate)
	-- body
end