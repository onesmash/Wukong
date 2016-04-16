local Class = require('Class')
local Texture = require('Texture')
local Sprite = require('Sprite')
local SpriteRenderer = require('SpriteRenderer')
local Entity = require('Entity')
local ExplosionBehaviour = require('ExplosionBehaviour')

local modName = ...

local Explosion = Class(modName, Entity)

_G[modName] = Explosion
package.loaded[modName] = Explosion

local print = print

local _ENV = Explosion

function init(self)
	super.init(self)
	self.frames = 12
	local texture = Texture()
	texture:loadImage('explosion.png')
	local sprite = Sprite(texture, {x = 0, y = 0, w = texture.width / self.frames, h = texture.height})
	sprite.center = {x = 0.5, y = 0.5}
	local renderer = self:addComponent(SpriteRenderer)
	renderer.sprite = sprite
	self:addComponent(ExplosionBehaviour)
end