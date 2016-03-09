local Scene = require('Scene')
local Texture = require('Texture')
local Sprite = require('Sprite')
local Renderer = require('Renderer')
local Entity = require('Entity')
local ShipBehaviour = require('ShipBehaviour')

local scene = Scene()

local texture = Texture()
texture:loadImage('shipAnimation.png')

local sprite = Sprite(texture, {x = 0, y = 0, w = 115, h = 69})

local ship = Entity()
ship:addComponent(Renderer)
local renderer = ship:getComponent(Renderer)
renderer.sprite = sprite
ship:addComponent(ShipBehaviour)

scene:addEntity(ship)

wukongEngine:loadScene(scene)

wukongEngine:start()