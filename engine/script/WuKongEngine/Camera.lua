local Class = require('Class')
local Component = require('Component')
local Runtime = require('runtime')
local Renderer = require('Renderer')

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
	local entityPosition = entity:getTransform():getPosition()
	local entitySprite = entity:getComponent(Renderer).sprite
	local localPsition = self.transform:inverseTransformPoint(entityPosition.x, entityPosition.y)
	local entityTop = localPsition.y - entitySprite.height * entitySprite.center.y
	local entityBottom = entityTop + entitySprite.height
	local entityLeft = localPsition.x - entitySprite.width * entitySprite.center.x
	local entityRight = entityLeft + entitySprite.width
	--print(entityLeft, entityRight)

	local viewTop = -self.pixelHeight / 2
	local viewBottom = viewTop + self.pixelHeight
	local viewLeft = -self.pixelWidth / 2
	local viewRight = viewLeft + self.pixelWidth

	
	--print('view', viewTop, viewLeft, viewBottom, viewRight)
	if entityLeft >= viewRight or entityRight <= viewLeft or entityBottom <= viewTop or entityTop >= viewBottom then
		--print(entity.name, 'not visible', entityTop, entityLeft, entityBottom, entityRight)
		return false
	end
	--print(entity.name, 'visible', entityTop, entityLeft, entityBottom, entityRight)
	return true
end

function addPreRenderDelegate(self, delegate)
	
end

function addPostRenderDelegate(self, delegate)
	-- body
end