local Scene = require('Scene')
local Texture = require('Texture')
local Sprite = require('Sprite')
local Renderer = require('Renderer')
local Behaviour = require('Behaviour')
local SpriteRenderer = require('SpriteRenderer')
local Entity = require('Entity')
local Ship = require('Ship')
local Background = require('Background')

local scene = Scene()

local background1 = Background('mainbackground.png', Renderer.sortingOrder.defalutOrder + 3, 15)
scene:addEntity(background1)

local background2 = Background('bgLayer1.png', Renderer.sortingOrder.defalutOrder + 2, 20)
scene:addEntity(background2)

local background3 = Background('bgLayer2.png', Renderer.sortingOrder.defalutOrder + 1, -25)
scene:addEntity(background3)

local ship = Ship()

scene:addEntity(ship)

WukongEngine:loadScene(scene, false)

WukongEngine:start()