local Class = require('Class')
local GameObject = require('GameObject')
local Transform = require('Transform')
local Component = require('Component')
local Behaviour = require('Behaviour')
local Renderer = require('Renderer')
local Collider = require('Collider')
local Vector3 = require('Vector3')
local AABB = require('AABB')

local modName = ...

local Entity = Class(modName, GameObject, false)

_G[modName] = Entity
package.loaded[modName] = Entity

local string = string
local table = table
local ipairs = ipairs
local print = print
local math = math

local _ENV = Entity

local function firstCharacterLowercase(str)
	return string.gsub(str, '^%u', string.lower)
end

function static.destroy(entity)
	local scene = entity:getScene()
	if scene then
		scene:removeEntity(entity)
		--print('remove entity')
	end
end

function init(self)
	super.init(self)
	self._components = {}
	self:addComponent(Transform)
	self._children = {}
	self._proxyId = -1
end

function setScene(self, scene)
	if scene then
		local broadPhase = scene:getBroadPhase()
		self:enumerate(function(entity)
			entity._scene = scene
			if broadPhase then
				local aabb = self:getAABB()
				if aabb then
					self._proxyId = broadPhase:createProxy(aabb, entity)
					--print(self._proxyId)
				end
			end
			return true
		end)
	elseif self:getScene() then
		local broadPhase = self:getScene():getBroadPhase()
		self:enumerate(function(entity)
			entity._scene = scene
			if broadPhase then
				broadPhase:destroyProxy(self._proxyId)
				self._proxyId = -1
			end
			return true
		end)
	end
	
end

function getScene(self)
	return self._scene
end

function getTransform(self)
	return self._components.transform
end

function moveProxy(self, displacement)
	local scene = self:getScene()
	local broadPhase = scene and scene:getBroadPhase()
	if not broadPhase then
		return
	end
	self:enumerate(function(entity)
		local aabb = entity:getAABB()
		if aabb and entity._proxyId ~= -1 then
			broadPhase:moveProxy(entity._proxyId, aabb, displacement)
		end
		return true
	end)
end

function getAABB(self)
	local spriteAABB = self:getSpriteAABB()
	local colliderAABB = self:getColliderAABB()
	if not spriteAABB and not colliderAABB then
		return nil
	elseif not spriteAABB then
		return colliderAABB
	elseif not colliderAABB then
		return spriteAABB
	else
		spriteAABB:combine(colliderAABB)
	end
end

function getSpriteAABB(self)
	local renderer = self:getComponent(Renderer)
	if not renderer then
		return nil
	end
	local sprite = renderer.sprite
	local transform = self:getTransform()
	local centerLeftWidth = sprite.width * sprite.center.x
	local centerBottomHeight = sprite.height * sprite.center.y

	local localTopLeft = Vector3(-centerLeftWidth, sprite.height - centerBottomHeight, 0)
	local localTopRight = Vector3(sprite.width - centerLeftWidth, sprite.height - centerBottomHeight, 0)
	local localBottomLeft = Vector3(-centerLeftWidth, -centerBottomHeight, 0)
	local localBottomRight = Vector3(sprite.width - centerLeftWidth, - centerBottomHeight, 0)

	local topLeft = transform:transformPoint(localTopLeft.x, localTopLeft.y)
	local topRight = transform:transformPoint(localTopRight.x, localTopRight.y)
	local bottomLeft = transform:transformPoint(localBottomLeft.x, localBottomLeft.y)
	local bottomRight = transform:transformPoint(localBottomRight.x, localBottomRight.y)

	local minX math.min(topLeft.x, topRight.x, bottomLeft.x, bottomRight.x)
	local minY = math.min(topLeft.y, topRight.y, bottomLeft.y, bottomRight.y)
	local maxX math.max(topLeft.x, topRight.x, bottomLeft.x, bottomRight.x)
	local maxY = math.max(topLeft.y, topRight.y, bottomLeft.y, bottomRight.y)

	return AABB(Vector3(minX, minY, 0), Vector3(maxX, maxY))
end

function getColliderAABB(self)
	local collider = self:getComponent(Collider)
	if not collider or collider.width <= 0 or collider.height <= 0 then
		return nil
	end
	
	local transform = self:getTransform()
	local centerLeftWidth = collider.width * collider.center.x
	local centerBottomHeight = collider.height * collider.center.y

	local localTopLeft = Vector3(-centerLeftWidth, collider.height - centerBottomHeight, 0)
	local localTopRight = Vector3(collider.width - centerLeftWidth, collider.height - centerBottomHeight, 0)
	local localBottomLeft = Vector3(-centerLeftWidth, -centerBottomHeight, 0)
	local localBottomRight = Vector3(collider.width - centerLeftWidth, - centerBottomHeight, 0)

	local topLeft = transform:transformPoint(localTopLeft.x, localTopLeft.y)
	local topRight = transform:transformPoint(localTopRight.x, localTopRight.y)
	local bottomLeft = transform:transformPoint(localBottomLeft.x, localBottomLeft.y)
	local bottomRight = transform:transformPoint(localBottomRight.x, localBottomRight.y)

	local minX math.min(topLeft.x, topRight.x, bottomLeft.x, bottomRight.x)
	local minY = math.min(topLeft.y, topRight.y, bottomLeft.y, bottomRight.y)
	local maxX math.max(topLeft.x, topRight.x, bottomLeft.x, bottomRight.x)
	local maxY = math.max(topLeft.y, topRight.y, bottomLeft.y, bottomRight.y)

	return AABB(Vector3(minX, minY, 0), Vector3(maxX, maxY))
end

function addComponent(self, componentClass)
	local component = componentClass()
	if not component:isKindOf(Component) then
		return
	end
	local componentName = (component:isKindOf(Behaviour) and 'behaviour') or (component:isKindOf(Renderer) and 'renderer') or (component:isKindOf(Collider) and 'collider') or firstCharacterLowercase(componentClass.className)
	self._components[componentName] = component
	component:setEntity(self)
	component:setTransform(self._components.transform)
	return component
end

function getComponent(self, componentClass)
	--print(self.className, componentClass)
	local componentName = firstCharacterLowercase(componentClass.className)
	return self._components[componentName]
end

function addChild(self, entity)
	if entity._parent then
		entity._parent:removeChild(entity)
	end
	entity._parent = self;
	local transform = entity:getTransform()
	transform:setParent(self._components.transform)
	table.insert(self._children, entity)
	local scene = self:getScene()
	if scene then
		scene:resetDelegates(entity)
		entity:setScene(scene)
	end
end

function removeChild(self, entity)
	local index = 0
	for key, value in ipairs(self._children) do
		if value == entity then
			index = key
			break
		end
	end
	table.remove(self._children, index)
	local transform = entity:getTransform()
	transform:setParent(nil)
	local scene = self:getScene()
	if scene then
		scene:removeDelegates(entity)
		entity:setScene(nil)
	end
end

function enumerate(self, f)
	if not f(self) then
		return
	end
	for _, entity in ipairs(self._children) do
		entity:enumerate(f)
	end
end