local Class = require('Class')
local GameObject = require('GameObject')
local Behaviour = require('Behaviour')
local Renderer = require('Renderer')
local BroadPhase = require('BroadPhase')
local Collider = require('Collider')
local Collision = require('Collision')
local AABB = require('AABB')
local Touch = require('Touch')
local Vector3 = require('Vector3')

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
	self._visibleEntities = {}
	self._broadPhase = BroadPhase()
	self._collisions = {}
	local mt = {__mode = 'k'}
	self._startDelegates = setmetatable({}, mt)
	self._updateDelegates = setmetatable({}, mt)
	--self._renderDelegates = setmetatable({}, mt)
	--self._orderedRenderDelegates = setmetatable({}, {__mode = 'v'})
	--self._needSortRenderOrder = true
end

function getMainCamera(self)
	return self._mainCamera
end

function setMainCamera(self, camera)
	if self._mainCamera then
		self:removeDelegates(self._mainCamera.entity)
		self._mainCamera.entity:setScene(nil)
	end
	self._mainCamera = camera
	self:resetDelegates(camera.entity)
	self._mainCamera.entity:setScene(self)
end

function getBroadPhase(self)
	return self._broadPhase
end

function addEntity(self, entity)
	entity:setScene(self)
	self._entities[entity] = 1
	self:resetDelegates(entity)
end

function removeEntity(self, entity)
	entity:setScene(nil)
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
		if behaviour._started and behaviour.enabled then
			behaviour:update()
			if behaviour.entity.selected == true and behaviour.onDrag then
				behaviour:onDrag()
			end
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
			if renderer then
				if renderer.isVisible then
					--if self._mainCamera:isVisibleByMe(entity) then
					table.insert(renderers, renderer)
					--end
					return true
				else
					return false
				end
			end
			return true
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

-- updatePairs callback
function addPair(self, a, b)
	local colliderA = a:getComponent(Collider)
	local colliderB = b:getComponent(Collider)
	if colliderA and colliderB and colliderA:testCollide(colliderB) then
		local colliderPair = {colliderA, colliderB}
		table.insert(self._collisions, colliderPair)
	end
end

function queryCallback(self, proxyId)
	local entity = self._broadPhase:getData(proxyId)
	if self._mainCamera:isVisibleByMe(entity) then
		table.insert(self._visibleEntities, entity);
	end
	return true
end

function onCollide(self)
	self._collisions = {}
	self._broadPhase:updatePairs(self)
	for _, colliderPair in ipairs(self._collisions) do
		local behaviourA = colliderPair[1].entity:getComponent(Behaviour)
		local behaviourB = colliderPair[2].entity:getComponent(Behaviour)
		if type(behaviourA.onCollide) == 'function' then
			local collision = Collision(colliderPair[2])
			behaviourA:onCollide(collision)
		end
		if type(behaviourB.onCollide) == 'function' then
			local collision = Collision(colliderPair[1])
			behaviourB:onCollide(collision)
		end
	end
end

function onGUIEvent(self, input)
	local touch = input.touches[1]
	if touch then
		if touch.phase == Touch.began then
			local position = Vector3(input.mousePosition.x, input.mousePosition.y, 0)
			local v = Vector3(1, 1, 1)
			local touchAABB = AABB(position - v, position + v)
			local proxyIds = self._broadPhase:query(nil, touchAABB)
			for _, proxyId in ipairs(proxyIds) do
				local entity = self._broadPhase:getData(proxyId)
				entity.selected = true
			end
		elseif touch.phase == Touch.End then
			local position = Vector3(input.mousePosition.x, input.mousePosition.y, 0)
			local v = Vector3(1, 1, 1)
			local touchAABB = AABB(position - v, position + v)
			local proxyIds = self._broadPhase:query(nil, touchAABB)
			for _, proxyId in ipairs(proxyIds) do
				local entity = self._broadPhase:getData(proxyId)
				entity.selected = false
			end
		elseif touch.phase == Touch.moved then
		end
	end
end

function createRenderPath(self)
	local renderers = {}
	for _, entity in pairs(self._visibleEntities) do
		entity:enumerate(function(entity)
			local renderer = entity:getComponent(Renderer)
			if renderer then
				if renderer.isVisible then
					table.insert(renderers, renderer)
					return true
				else
					return false
				end
			end
			return true
		end)
	end

	table.sort(renderers, function(a, b)
		if a.sortingLayer ~= b.sortingLayer then
			return a.sortingLayer > b.sortingLayer
		else
			return a.sortingOrder > b.sortingOrder
		end
	end)

	--print(#self._visibleEntities)
	--print(#renderers)
	self._visibleEntities = {}
	return renderers
end

function onRender(self)
	self._visibleEntities = {}
	local cameraViewLowerBound = self._mainCamera:viewportToWorldPoint(0, 0)
	local cameraViewUpperBound = self._mainCamera:viewportToWorldPoint(1, 1)
	local aabb = AABB(cameraViewLowerBound, cameraViewUpperBound)
	--print(cameraViewLowerBound.x, cameraViewLowerBound.y)
	--print(cameraViewUpperBound.x, cameraViewUpperBound.y)
	self._broadPhase:query(self, aabb)
	Renderer.renderBegin()
	if self._mainCamera.needClear then
		Renderer.clear(self._mainCamera.backgroundColor)
	end
	local renderers = self:createRenderPath()
	for _, renderer in ipairs(renderers) do
		renderer:render()
	end
	Renderer.present()
	Renderer.renderEnd()
end