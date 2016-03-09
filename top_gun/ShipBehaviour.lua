local Class = require('Class')
local Behaviour = require('Behaviour')
local Renderer = require('Renderer')
local Time = require('runtime.time')

local modName = ...

local ShipBehaviour = Class(modName, Behaviour, true)

_G[modName] = ShipBehaviour
package.loaded[modName] = ShipBehaviour

local print = print

local _ENV = ShipBehaviour

function init(self)
	super.init(self)
end

function start(self)
	print('ShipBehaviour started')
	self.transform.position.x = 100
	self.transform.position.y = 100
	self._renderer = self.entity:getComponent(Renderer)
	self._sprite = self._renderer.sprite
	self._texture = self._sprite.texture
	self._frames = self._texture.width / self._sprite.width
	self._frameIndex = 0
	--self:startCoroutine(function()
		
	--end)
end

function update(self)
	self._frameIndex = (self._frameIndex + 1) % self._frames
	--print(self._frameIndex)
	self._sprite.rect.x = self._frameIndex * self._sprite.rect.w
end