local Class = require('Class')
local Texture = require('Texture')
local Sprite = require('Sprite')
local SpriteRenderer = require('SpriteRenderer')
local Entity = require('Entity')
local BackgroundBehaviour = require('BackgroundBehaviour')

local modName = ...

local Background = Class(modName, Entity)

_G[modName] = Background
package.loaded[modName] = Background

local print = print

local _ENV = Background

function init(self, imagePath, sortingOrder, speed)
	super.init(self)
	local behaviour = self:addComponent(BackgroundBehaviour)
	behaviour.sortingOrder = sortingOrder
	behaviour.speed = speed
	behaviour.imagePath = imagePath
end