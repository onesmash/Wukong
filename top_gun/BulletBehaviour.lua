local Class = require('Class')
local Behaviour = require('Behaviour')
local Coroutine = require('Coroutine')
local Entity = require('Entity')
local Renderer = require('Renderer')
local Collider = require('Collider')

local modName = ...

local BulletBehaviour = Class(modName, Behaviour, true)

_G[modName] = BulletBehaviour
package.loaded[modName] = BulletBehaviour

local print = print
local Time = WukongEngine.Time
local _ENV = BulletBehaviour

function init(self)
	super.init(self)
	self._speed = 150
end

function start(self)
	super.start(self)
	--print('BulletBehaviour started')
	self:startCoroutine(function()
		Coroutine.waitForSeconds(10)
		Entity.destroy(self.entity)
	end)
end

function update(self)
	self.transform:translate(self._speed * Time.deltaTime, 0, true)
end

function onCollide(self, collision)
	self.enabled = false
	local otherCollider = collision.collider
	local collider = self.entity:getComponent(Collider)
	--if otherCollider.className == collider.className then
	--	return
	--end
	collider.enabled = false
	local renderer = self.entity:getComponent(Renderer)
	renderer.isVisible = false
	Entity.destroy(self.entity)
end