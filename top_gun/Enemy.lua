local Class = require('Class')
local Texture = require('Texture')
local Sprite = require('Sprite')
local SpriteRenderer = require('SpriteRenderer')
local Entity = require('Entity')
local EnemyBehaviour = require('EnemyBehaviour')

local modName = ...

local Enemy = Class(modName, Entity)

_G[modName] = Enemy
package.loaded[modName] = Enemy

local print = print

local _ENV = Enemy

function init(self)
	super.init(self)
	self._texture = Texture()
	self._texture:loadImage('mineAnimation.png')
	self._sprite = Sprite(self._texture, {x = 0, y = 0, w = self._texture.width / 8, h = self._texture.height})
	self._sprite.center = {x = 0.5, y = 0.5}
	self._renderer = self:addComponent(SpriteRenderer)
	self._renderer.sprite = self._sprite
	self:addComponent(EnemyBehaviour)
end