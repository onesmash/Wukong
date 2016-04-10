local Class = require('Class')
local Behaviour = require('Behaviour')
local Coroutine = require('Coroutine')
local Entity = require('Entity')

local modName = ...

local BulletBehaviour = Class(modName, Behaviour, true)

_G[modName] = BulletBehaviour
package.loaded[modName] = BulletBehaviour

local print = print
local Time = WukongEngine.Time
local _ENV = BulletBehaviour

function init(self)
	super.init(self)
	self._speed = 50
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