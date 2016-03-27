local Class = require('Class')
local Behaviour = require('Behaviour')
local Renderer = require('Renderer')
local SpriteRenderer = require('SpriteRenderer')

local modName = ...

local ShipBehaviour = Class(modName, Behaviour, true)

_G[modName] = ShipBehaviour
package.loaded[modName] = ShipBehaviour

local print = print
local Input = WukongEngine.Input

local _ENV = ShipBehaviour

function init(self)
	super.init(self)
end

function start(self)
	super.start(self)
	print('ShipBehaviour started')
	self.entity:getScene():getMainCamera().needClear = true
	self.transform:setPosition(200, 0)
	--self.transform:rotate(-20, false)
	--self.transform.position.x = 100
	--self.transform.position.y = 200
	self._renderer = self.entity:getComponent(Renderer)
	print(self._renderer.className)
	self._sprite = self._renderer.sprite
	self._texture = self._sprite.texture
	self._frames = self._texture.width / self._sprite.width
	self._frameIndex = 0
end

function update(self)
	self._frameIndex = (self._frameIndex + 1) % self._frames
	--print(self._frameIndex)
	self._sprite.rect.x = self._frameIndex * self._sprite.rect.w
	--print(Input.mouseDelta.x)
	--print(Input.mouseDelta.y)
	self.transform:setPosition(Input.mousePosition.x, Input.mousePosition.y)
	--self.transform:rotate(1, false)
	--print(self.transform._localRotation)
	--self.transform.position.x = Input.mousePosition.x
	--self.transform.position.y = Input.mousePosition.y
end