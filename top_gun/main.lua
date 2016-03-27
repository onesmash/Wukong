local Scene = require('Scene')
local Texture = require('Texture')
local Sprite = require('Sprite')
local Renderer = require('Renderer')
local Behaviour = require('Behaviour')
local SpriteRenderer = require('SpriteRenderer')
local Entity = require('Entity')
local ShipBehaviour = require('ShipBehaviour')
local BackgroundBehaviour = require('BackgroundBehaviour')

local scene = Scene()

local backgroundLayer1 = Entity()
backgroundLayer1.name = 'background'
backgroundLayer1:addComponent(BackgroundBehaviour)
local backgroundLayer1Behaviour = backgroundLayer1:getComponent(Behaviour)
backgroundLayer1Behaviour.sortingOrder = Renderer.sortingOrder.defalutOrder + 3
backgroundLayer1Behaviour.speed = -15
backgroundLayer1Behaviour.imagePath = 'mainbackground.png' 
scene:addEntity(backgroundLayer1)

local backgroundLayer2 = Entity()
backgroundLayer2.name = 'background'
backgroundLayer2:addComponent(BackgroundBehaviour)
local backgroundLayer2Behaviour = backgroundLayer2:getComponent(Behaviour)
backgroundLayer2Behaviour.sortingOrder = Renderer.sortingOrder.defalutOrder + 2
backgroundLayer2Behaviour.speed = 20
backgroundLayer2Behaviour.imagePath = 'bgLayer1.png' 
scene:addEntity(backgroundLayer2)

local backgroundLayer3 = Entity()
backgroundLayer3.name = 'background'
backgroundLayer3:addComponent(BackgroundBehaviour)
local backgroundLayer3Behaviour = backgroundLayer3:getComponent(Behaviour)
backgroundLayer3Behaviour.sortingOrder = Renderer.sortingOrder.defalutOrder + 1
backgroundLayer3Behaviour.speed = -25
backgroundLayer3Behaviour.imagePath = 'bgLayer2.png' 
scene:addEntity(backgroundLayer3)

local shipTexture = Texture()
shipTexture:loadImage('shipAnimation.png')

local shipSprite = Sprite(shipTexture, {x = 0, y = 0, w = 115, h = 69})

local ship = Entity()
ship.name = 'ship'
ship:addComponent(SpriteRenderer)
local renderer = ship:getComponent(Renderer)
renderer.sprite = shipSprite
ship:addComponent(ShipBehaviour)

scene:addEntity(ship)

WukongEngine:loadScene(scene, false)

WukongEngine:start()