local Class = require('Class')
local Texture = require('Texture')
local Sprite = require('Sprite')
local SpriteRenderer = require('SpriteRenderer')
local Entity = require('Entity')
local BulletBehaviour = require('BulletBehaviour')
local BoxCollider = require('BoxCollider')

local modName = ...

local Bullet = Class(modName, Entity)

_G[modName] = Bullet
package.loaded[modName] = Bullet

local print = print

local _ENV = Bullet

function init(self)
	super.init(self)
	self._texture = Texture()
	self._texture:loadImage('laser.png')
	self._sprite = Sprite(self._texture, {x = 0, y = 0, w = self._texture.width, h = self._texture.height})
	self._sprite.center = {x = 0, y = 0.5}
	self._renderer = self:addComponent(SpriteRenderer)
	self._renderer.sprite = self._sprite
	self:addComponent(BulletBehaviour)
	self._collider = self:addComponent(BoxCollider)
	self._collider.center = self._sprite.center
	self._collider.width = self._sprite.width
	self._collider.height = self._sprite.height
end