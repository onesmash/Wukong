local Class = require('Class')
local Texture = require('Texture')
local Sprite = require('Sprite')
local SpriteRenderer = require('SpriteRenderer')
local Entity = require('Entity')
local EnemyBehaviour = require('EnemyBehaviour')
local BoxCollider = require('BoxCollider')

local modName = ...

local Enemy = Class(modName, Entity)

_G[modName] = Enemy
package.loaded[modName] = Enemy

local print = print

local _ENV = Enemy

local texture = Texture()
texture:loadImage('mineAnimation.png')

function init(self)
	super.init(self)
	local sprite = Sprite(texture, {x = 0, y = 0, w = texture.width / 8, h = texture.height})
	sprite.center = {x = 0.5, y = 0.5}
	local renderer = self:addComponent(SpriteRenderer)
	renderer.sprite = sprite
	self:addComponent(EnemyBehaviour)
	local collider = self:addComponent(BoxCollider)
	collider.center = sprite.center
	collider.width = sprite.width
	collider.height = sprite.height
end