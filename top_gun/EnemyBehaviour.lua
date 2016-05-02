local Class = require('Class')
local Behaviour = require('Behaviour')
local Renderer = require('Renderer')
local SpriteRenderer = require('SpriteRenderer')
local Entity = require('Entity')
local Texture = require('Texture')
local Coroutine = require('Coroutine')
local Sprite = require('Sprite')
local Collider = require('Collider')
local Explosion = require('Explosion')
local AudioSource = require('AudioSource')

local modName = ...

local EnemyBehaviour = Class(modName, Behaviour, true)

_G[modName] = EnemyBehaviour
package.loaded[modName] = EnemyBehaviour

local print = print
local math = math
local Time = WukongEngine.Time

local _ENV = EnemyBehaviour

function init(self)
	super.init(self)
end

function start(self)
	super.start(self)

	local camera = self.entity:getScene():getMainCamera()
	local position = camera:viewportToWorldPoint(1 + math.random(), math.random())
	self.transform:setPosition(position.x, position.y)
	
	self._renderer = self.entity:getComponent(Renderer)
	self._sprite = self._renderer.sprite
	self._frames = self._sprite.texture.width / self._sprite.width
	self._frameIndex = 0

	self:startCoroutine(function()
		Coroutine.waitForSeconds(60)
		Entity.destroy(self.entity)
	end)
end

function update(self)
	self._frameIndex = (self._frameIndex + 1) % self._frames
	self._sprite.rect.x = self._frameIndex * self._sprite.rect.w
	self.transform:translate(-20 * Time.deltaTime, 0, true)
end

function onCollide(self, collision)
	self.enabled = false
	local collider = self.entity:getComponent(Collider)
	collider.enabled = false
	local renderer = self.entity:getComponent(Renderer)
	renderer.isVisible = false
	local explosion = Explosion()
	local transform = explosion:getTransform()
	local position = self.transform:getPosition()
	transform:setPosition(position.x, position.y)
	local scene = self.entity:getScene()
	if scene then
		scene:addEntity(explosion)
		local audioSource = explosion:getComponent(AudioSource)
		audioSource:setClip(self.entity.explosionSound)
		Entity.destroy(self.entity)
	end
	
end