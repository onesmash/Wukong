local Class = require('Class')
local Behaviour = require('Behaviour')
local Texture = require('Texture')
local Sprite = require('Sprite')
local Renderer = require('Renderer')
local SpriteRenderer = require('SpriteRenderer')
local Entity = require('Entity')
local Enemy = require('Enemy')
local Coroutine = require('Coroutine')
local AudioClip = require('AudioClip')

local modName = ...

local BackgroudnBehaviour = Class(modName, Behaviour, true)

_G[modName] = BackgroudnBehaviour
package.loaded[modName] = BackgroudnBehaviour

local print = print

local Time = WukongEngine.Time

local _ENV = BackgroudnBehaviour

function init(self)
	super.init(self)
	self.speed = -20
	self.imagePath = 'mainbackground.png'
	self.sortingLayer = Renderer.sortingLayer.defaultLayer
	self.sortingOrder = Renderer.sortingOrder.defalutOrder
end

function start(self)
	super.start(self)
	print('BackgroundBehaviour started')
	self.entity:getScene():getMainCamera().needClear = true
	self._layer11 = Entity()
	self._layer11.name = 'layer11'
	self._layer11:addComponent(SpriteRenderer)
	self._texture = Texture()
	self._texture:loadImage(self.imagePath)
	local layer11Renderer = self._layer11:getComponent(Renderer)
	layer11Renderer.sortingOrder = self.sortingOrder
	layer11Renderer.sprite = Sprite(self._texture, {x = 0, y = 0, w = self._texture.width, h = self._texture.height})
	self.entity:addChild(self._layer11)

	self._layer12 = Entity()
	self._layer12.name = 'layer12'
	self._layer12:addComponent(SpriteRenderer)
	local layer12Renderer = self._layer12:getComponent(Renderer)
	layer12Renderer.sortingOrder = self.sortingOrder
	layer12Renderer.sprite = Sprite(self._texture, {x = 0, y = 0, w = self._texture.width, h = self._texture.height})
	self.entity:addChild(self._layer12)
	local mainCamera = self.entity:getScene():getMainCamera()
	if self.speed < 0 then
		layer11Renderer.sprite.center = {x = 0, y = 0.5}
		layer12Renderer.sprite.center = {x = 0, y = 0.5}
		self._layer11:getTransform():setPosition(0, mainCamera.pixelHeight / 2)
		self._layer12:getTransform():setPosition(self._texture.width, mainCamera.pixelHeight / 2)
	else
		layer11Renderer.sprite.center = {x = 1, y = 0.5}
		layer12Renderer.sprite.center = {x = 1, y = 0.5}
		self._layer11:getTransform():setPosition(mainCamera.pixelWidth, mainCamera.pixelHeight / 2)
		self._layer12:getTransform():setPosition(mainCamera.pixelWidth - self._texture.width, mainCamera.pixelHeight / 2)
	end

	local explosionSound = AudioClip('explosion.wav')

	self:startCoroutine(function()
		while true do
			local enemy = Enemy() 
			enemy.explosionSound = explosionSound
			self.entity:getScene():addEntity(enemy)
			Coroutine.waitForSeconds(1)
		end
	end)
end

function update(self)
	self._layer11:getTransform():translate(Time.deltaTime * self.speed, 0)
	self._layer12:getTransform():translate(Time.deltaTime * self.speed, 0)
	local mainCamera = self.entity:getScene():getMainCamera()
	if not mainCamera:isVisibleByMe(self._layer11) then
		local layer12Position = self._layer12:getTransform():getPosition()
		if self.speed < 0 then
			self._layer11:getTransform():setPosition(layer12Position.x + self._texture.width, mainCamera.pixelHeight / 2)
		else
			self._layer11:getTransform():setPosition(layer12Position.x - self._texture.width, mainCamera.pixelHeight / 2)
		end
	end
	if not mainCamera:isVisibleByMe(self._layer12) then
		local layer11Position = self._layer11:getTransform():getPosition()
		if self.speed < 0 then
			self._layer12:getTransform():setPosition(layer11Position.x + self._texture.width, mainCamera.pixelHeight / 2)
		else
			self._layer12:getTransform():setPosition(layer11Position.x - self._texture.width, mainCamera.pixelHeight / 2)
		end
	end
end

function finalize(self)
	print('background finalize')
end