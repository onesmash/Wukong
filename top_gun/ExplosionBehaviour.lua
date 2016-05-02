local Class = require('Class')
local Renderer = require('Renderer')
local Entity = require('Entity')
local Coroutine = require('Coroutine')
local AudioSource = require('AudioSource')

local modName = ...

local ExplosionBehaviour = Class(modName, Behaviour, true)

_G[modName] = ExplosionBehaviour
package.loaded[modName] = ExplosionBehaviour

local print = print

local _ENV = ExplosionBehaviour

function init(self)
	super.init(self)
end

function start(self)
	super.start(self)
	local audioSource = self.entity:getComponent(AudioSource)
	audioSource:play(2)
	self:startCoroutine(function()
		for i = 0, self.entity.frames - 1 do
			--print('index ', i)
			local renderer = self.entity:getComponent(Renderer)
			renderer.sprite.rect.x = i * renderer.sprite.rect.w
			Coroutine.waitForSeconds(2 / self.entity.frames)
		end
		Entity.destroy(self.entity)
	end)
end