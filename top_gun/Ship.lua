local Class = require('Class')
local Texture = require('Texture')
local Sprite = require('Sprite')
local SpriteRenderer = require('SpriteRenderer')
local Entity = require('Entity')
local ShipBehaviour = require('ShipBehaviour')
local AudioSource = require('AudioSource')

local modName = ...

local Ship = Class(modName, Entity)

_G[modName] = Ship
package.loaded[modName] = Ship

local print = print

local _ENV = Ship

function init(self)
	super.init(self)
	self._texture = Texture()
	self._texture:loadImage('shipAnimation.png')
	self._sprite = Sprite(self._texture, {x = 0, y = 0, w = 115, h = 69})
	self._sprite.center = {x = 0.5, y = 0.5}
	self._renderer = self:addComponent(SpriteRenderer)
	self._renderer.sprite = self._sprite
	self:addComponent(ShipBehaviour)
	self:addComponent(AudioSource)
end