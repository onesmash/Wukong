local Class = require('Class')
local Object = require('Object')
local Runtime = require('runtime')
local Time = require('runtime.time')
local SDL = require('SDL')
local messageloop = require('runtime.messageloop')
local Renderer = require('Renderer')

local modName = ...

local WukongEngine = Class(modName, Object, false)

local print = print
local ipairs = ipairs

_G[modName] = WukongEngine
package.loaded[modName] = WukongEngine

local string = string

local _ENV = WukongEngine

local lastUpdateTime

local function doPenddingWorks()
	local penddingWorks = Runtime.penddingWorks;
	Runtime.penddingWorks = {}
	for i, work in ipairs(penddingWorks) do
		work()
	end
end

function init(self)
	super.init(self)
end

function loadScene(self, scene, additive)
	self._scene = scene;
	scene:onLoad()
end

local tick = 1 / 60

function update(self)
	local now = Time.now()
	local deltaTime = now - lastUpdateTime
	Time.deltaTime = deltaTime
	lastUpdateTime = now
	for e in SDL.pollEvent() do
		if e and e.type == SDL.event.MouseMotion then
			local state, x, y = SDL.getMouseState()
			local _, dx, dy = SDL.getRelativeMouseState()
			if state[SDL.mouseMask.Left] then
				--drawLine(x - dx, y - dy, dx, dy)
				--renderer:present()
			end
		end
	end
	--for _, service in pairs(runtime._services) do
	--		service:update()
	--end
	self._scene:onUpdate()
	doPenddingWorks()
	self._scene:onRender()
	now = Time.now()
	deltaTime = now - lastUpdateTime
	if deltaTime > tick then
		return self:update()
	else
		return messageloop.postDelayTask(function()
			self:update()
		end, tick - deltaTime)
	end
end

function start(self)
	Renderer.clear({r = 255, g = 255, b = 255, a = 255})
	lastUpdateTime = Time.now()
	self:update()
end