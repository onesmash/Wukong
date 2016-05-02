local Class = require('Class')
local Behaviour = require('Behaviour')
local Renderer = require('Renderer')
local SpriteRenderer = require('SpriteRenderer')
local Entity = require('Entity')
local Texture = require('Texture')
local Coroutine = require('Coroutine')
local Sprite = require('Sprite')
local Bullet = require('Bullet')
local AudioClip = require('AudioClip')
local AudioSource = require('AudioSource')
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
	self._renderer = self.entity:getComponent(Renderer)
	self._sprite = self._renderer.sprite
	self._texture = self._sprite.texture
	self._frames = self._texture.width / self._sprite.width
	self._frameIndex = 0
	local audioSource = self.entity:getComponent(AudioSource)
	local fireSound = AudioClip('laserFire.wav')
	audioSource:setClip(fireSound)
	--self.transform:rotate(30, true)
	self:startCoroutine(function()
		while true do
			local bullet = Bullet()
			local transform = bullet:getTransform()
			transform:setLocalRotation(self.transform:getLocalRotation())
			local startPosition = self.transform:transformPoint(self._sprite.width / 2, 0)
			transform:setPosition(startPosition.x, startPosition.y) 
			self.entity:getScene():addEntity(bullet)
			audioSource:play()
			Coroutine.waitForSeconds(0.5)
		end
	end)
end

function update(self)
	--local bullet = Bullet()
	--bullet:getTransform():setPosition(self.transform:getPosition().x + self._sprite.width / 2, self.transform:getPosition().y)
	--self.entity:getScene():addEntity(bullet)

	self._frameIndex = (self._frameIndex + 1) % self._frames
	--print(self._frameIndex)
	self._sprite.rect.x = self._frameIndex * self._sprite.rect.w
	--print(Input.mouseDelta.x)
	--print(Input.mouseDelta.y)
	self.transform:setPosition(Input.mousePosition.x, Input.mousePosition.y)
	self.transform:rotate(1, true)
	--print(self.transform._localRotation)
	--self.transform.position.x = Input.mousePosition.x
	--self.transform.position.y = Input.mousePosition.y
end