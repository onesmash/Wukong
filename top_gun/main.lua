local Scene = require('Scene')
local Texture = require('Texture')
local Sprite = require('Sprite')
local Renderer = require('Renderer')
local Behaviour = require('Behaviour')
local SpriteRenderer = require('SpriteRenderer')
local Entity = require('Entity')
local Ship = require('Ship')
local Background = require('Background')
local UILabel = require('UILabel')
local UIFont = require('UIFont')

local scene = Scene()

local background1 = Background('mainbackground.png', Renderer.sortingOrder.defalutOrder + 3, 15)
scene:addEntity(background1)

local background2 = Background('bgLayer1.png', Renderer.sortingOrder.defalutOrder + 2, 20)
scene:addEntity(background2)

local background3 = Background('bgLayer2.png', Renderer.sortingOrder.defalutOrder + 1, -25)
scene:addEntity(background3)

local ship = Ship()

scene:addEntity(ship)

local font = UIFont('Hiragino Sans GB W3.ttf', 13)
local  label = UILabel(150, 150, 0, 0)
label:setWorldSpace(false)
label:setFont(font)
label:setTextColor(100, 0, 0, 255)
label:setText('Hello World!\n你好世界!')
label:getTransform():setPosition(150, 0, 0)
scene:getUIRoot():addSubview(label)

WukongEngine:loadScene(scene, false)

WukongEngine:start()