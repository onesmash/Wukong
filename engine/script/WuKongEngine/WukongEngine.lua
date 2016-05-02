local Class = require('Class')
local Object = require('Object')
local Runtime = require('runtime')
local Time = require('runtime.time')
local messageloop = require('runtime.messageloop')
local SDL = require('SDL')
local Camera = require('Camera')
local Entity = require('Entity')
local Touch = require('Touch')

local modName = ...

local WukongEngine = Class(modName, Object, false)

local print = print
local ipairs = ipairs
local setmetatable = setmetatable

_G[modName] = WukongEngine
package.loaded[modName] = WukongEngine

local string = string
local math = math

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
	self._started = false
	self.Time = {}
	self.Input = {mousePosition = {x = 0, y = 0}, mouseDelta = {x = 0, y = 0}, touches = {}}
	self._cameraEntity = Entity()
	self._cameraEntity:addComponent(Camera)
	self._mainCamera = self._cameraEntity:getComponent(Camera)
	self._mainCamera.transform:setPosition(Runtime.Device.displayInfo.w / 2, Runtime.Device.displayInfo.h / 2)
	--self._mainCamera.transform.position.x = Runtime.Device.displayInfo.w / 2
	--self._mainCamera.transform.position.y = Runtime.Device.displayInfo.h / 2
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

local tick = 1 / 60

function update(self) 
	local now = Time.now()
	local deltaTime = now - lastUpdateTime
	self.Time.deltaTime = deltaTime
	lastUpdateTime = now
	self.Input.mouseDelta.x = 0
	self.Input.mouseDelta.y = 0
	for e in SDL.pollEvent() do
		if e.type == SDL.event.FingerMotion then
			local state, x, y = SDL.getMouseState()
			local relativeState, dx, dy = SDL.getRelativeMouseState()
			local worldPosition = self._mainCamera:screenToWorldPoint(x, y)
			--print(state[SDL.mouseMask.Left], relativeState[SDL.mouseMask.Left])
			self.Input.mousePosition.x = worldPosition.x
			self.Input.mousePosition.y = worldPosition.y
			self.Input.mouseDelta.x = 0
			self.Input.mouseDelta.y = 0
			if state[SDL.mouseMask.Left] then
				self.Input.mouseDelta.x = dx or 0
				self.Input.mouseDelta.y = dy or 0
				local touch = Touch()
				touch.phase = Touch.Move
				self.Input.touches[SDL.mouseMask.Left] = touch
			end
		elseif e.type == SDL.event.MouseButtonDown then
			
		elseif e.type == SDL.event.FingerDown then
			local state, x, y = SDL.getMouseState()
			if state[SDL.mouseMask.Left] then
				local touch = Touch()
				touch.phase = Touch.Began
				self.Input.touches[SDL.mouseMask.Left] = touch
			else
			end
		elseif e.type == SDL.event.FingerUp then
			local state, x, y = SDL.getMouseState()
			if state[SDL.mouseMask.Left] then
				local touch = Touch()
				touch.phase = Touch.End
				self.Input.touches[SDL.mouseMask.Left] = touch
			else
			end
		end
	end
	
	self._scene:onUpdate()
	doPenddingWorks()
	self._scene:onCollide()
	self._scene:onRender()
	now = Time.now()
	deltaTime = now - lastUpdateTime
	local slot = math.max(tick - deltaTime, 0)
	--print(deltaTime, slot)
	--print(slot)
	if not self._started then
		return
	end
	return messageloop.postDelayTask(function()
			self:update()
	end, slot)
end

function start(self, duration)
	--Renderer.clear({r = 255, g = 255, b = 255, a = 255})
	self._started = true
	if duration then
		Runtime.startCoroutine(function()
			lastUpdateTime = Time.now()
			self:update()
			Runtime.waitForSeconds(duration)
			self._started = false
		end)
	else
		lastUpdateTime = Time.now()
		self:update()
	end
end