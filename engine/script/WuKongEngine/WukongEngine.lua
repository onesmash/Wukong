local Class = require('Class')
local Object = require('Object')
local Runtime = require('runtime')
local Time = require('runtime.time')
local messageloop = require('runtime.messageloop')
local SDL = require('SDL')
local Camera = require('Camera')
local Entity = require('Entity')

local modName = ...

local WukongEngine = Class(modName, Object, false)

local print = print
local ipairs = ipairs
local setmetatable = setmetatable

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
	self.Time = {}
	self.Input = {mousePosition = {x = 0, y = 0}, mouseDelta = {x = 0, y = 0}}
	self._cameraEntity = Entity()
	self._cameraEntity:addComponent(Camera)
	self._mainCamera = self._cameraEntity:getComponent(Camera)
	self._mainCamera.transform.position.x = Runtime.Device.displayInfo.w / 2
	self._mainCamera.transform.position.y = Runtime.Device.displayInfo.h / 2
end

function loadScene(self, scene, additive)
	if additive then
		for _, entity in ipairs(scene._entities) do
			self._scene:addEntity(entity)
		end
	else
		self._scene = scene;
		self._scene:setMainCamera(self._mainCamera)
	end
	scene:onLoad()
end

local tick = 1 / Runtime.Device.displayInfo.refreshRate

function update(self)
	local now = Time.now()
	local deltaTime = now - lastUpdateTime
	self.Time.deltaTime = deltaTime
	lastUpdateTime = now
	self.Input.mouseDelta.x = 0
	self.Input.mouseDelta.y = 0
	for e in SDL.pollEvent() do
		if e and e.type == SDL.event.MouseMotion then
			local state, x, y = SDL.getMouseState()
			local _, dx, dy = SDL.getRelativeMouseState()
			self.Input.mousePosition.x = x;
			self.Input.mousePosition.y = y
			if state[SDL.mouseMask.Left] then
				self.Input.mouseDelta.x = dx or 0
				self.Input.mouseDelta.y = dy or 0
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
	--Renderer.clear({r = 255, g = 255, b = 255, a = 255})
	lastUpdateTime = Time.now()
	self:update()
end