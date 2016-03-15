local Class = require('Class')
local GameObject = require('GameObject')
local Behaviour = require('Behaviour')
local Renderer = require('Renderer')

local modName = ...

local Scene = Class(modName, GameObject, false)

local table = table
local setmetatable = setmetatable
local type = type
local print = print
local ipairs = ipairs
local pairs = pairs

_G[modName] = Scene
package.loaded[modName] = Scene

local _ENV = Scene

function init(self)
	super.init(self)
	self._entities = {}
	local mt = {__mode = 'k'}
	self._startDelegates = setmetatable({}, mt)
	self._updateDelegates = setmetatable({}, mt)
	--self._renderDelegates = setmetatable({}, mt)
	self._orderedRenderDelegates = setmetatable({}, {__mode = 'v'})
	self._needSortRenderOrder = true
end

function setMainCamera(self, camera)
	if self._mainCamera then
		self:removeDelegates(self._mainCamera.entity)
		self._mainCamera.entity.scene = nil
	end
	self._mainCamera = camera
	self:resetDelegates(camera.entity)
	self._mainCamera.entity.scene = self
end

function addEntity(self, entity)
	entity.scene = self
	self._entities[entity] = 1
	self:resetDelegates(entity)
end

function removeEntity(self, entity)
	self._entities[entity] = nil
	self:removeDelegates(entity)
end

function setNeedSortRenderOrder(self)
	self._needSortRenderOrder = true
end

function addStartDelegate(self, behaviour)
	--table.insert(self._startDelegates, delegate)
	if behaviour and type(behaviour.start) == 'function' and (not behaviour._started) and behaviour.enabled then
		self._startDelegates[behaviour] = 1
	end
end

function removeStartDelegate(self, delegate)
	if delegate then
		self._startDelegates[delegate] = nil
	end
end

function addUpdateDelegate(self, behaviour)
	--table.insert(self._updateDelegates, delegate)
	if behaviour and type(behaviour.update) == 'function' and behaviour.enabled  then
		self._updateDelegates[behaviour] = 1
	end
end

function removeUpdateDelegate(self, delegate)
	if delegate then
		self._updateDelegates[delegate] = nil
	end
end

function resetDelegates(self, entity)
	entity:enumerate(function(entity)
		local behaviour = entity:getComponent(Behaviour)
		self:addStartDelegate(behaviour)
		self:addUpdateDelegate(behaviour)
		self:setNeedSortRenderOrder()
		return true
	end)
end

function removeDelegates(self, entity)
	entity:enumerate(function(entity)
		local behaviour = entity:getComponent(Behaviour)
		self:removeStartDelegate(behaviour)
		self:removeUpdateDelegate(behaviour)
		self:setNeedSortRenderOrder()
		return true
	end)
end

function onLoad(self)
	for _, entity in ipairs(self._entities) do
		self:resetDelegates(entity)
	end
end

function onUpdate(self)
	for behaviour, _ in pairs(self._startDelegates) do
		if (not behaviour._started) and behaviour.enabled then
			behaviour:start()
		end
		self._startDelegates[behaviour] = nil
		--(not behaviour._started) and behaviour.enabled and behaviour:start()
	end
	for behaviour, _ in pairs(self._updateDelegates) do
		if behaviour.enabled then
			behaviour:update()
		end
		--behaviour.enabled and behaviour:update()
	end
end

local function sortedTableKeys(t)
	local keys = {}
	for key, _ in pairs(t) do
		table.insert(keys, key)
	end
	table.sort(keys, function(a, b)
		return a > b
	end)
	return keys
end 

function sortRenderOrder(self)
	if not self._needSortRenderOrder then
		return
	end
	local renderers = setmetatable({}, {__mode = 'v'})
	for entity, _ in pairs(self._entities) do
		entity:enumerate(function(entity)
			local renderer = entity:getComponent(Renderer)
			if renderer.isVisible then
				if self._mainCamera:isVisibleByMe(entity) then
					table.insert(renderers, renderer)
				end
				return true
			end
			return false
		end)
	end

	table.sort(renderers, function(a, b)
		if a.sortingLayer ~= b.sortingLayer then
			return a.sortingLayer > b.sortingLayer
		else
			return a.sortingOrder > b.sortingOrder
		end
	end)

	self._orderedRenderDelegates = renderers
	self._needSortRenderOrder = false
end

function onRender(self)
	if self._mainCamera.needClear then
		Renderer.clear(self._mainCamera.backgroundColor)
	end
	self:sortRenderOrder()
	for _, renderer in ipairs(self._orderedRenderDelegates) do
		renderer:render()
	end
	Renderer.present()
end