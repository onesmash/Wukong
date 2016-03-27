local Class = require('Class')
local GameObject = require('GameObject')
local Transform = require('Transform')
local Component = require('Component')
local Behaviour = require('Behaviour')
local Renderer = require('Renderer')

local modName = ...

local Entity = Class(modName, GameObject, false)

_G[modName] = Entity
package.loaded[modName] = Entity

local string = string
local table = table
local ipairs = ipairs
local print = print

local _ENV = Entity

local function firstCharacterLowercase(str)
	return string.gsub(str, '^%u', string.lower)
end

function init(self)
	super.init(self)
	self._components = {}
	self:addComponent(Transform)
	self._children = {}
end

function setScene(self, scene)
	self:enumerate(function(entity)
		entity._scene = scene
		return true
	end)
end

function getScene(self)
	return self._scene
end

function getTransform(self)
	return self._components.transform
end

function addComponent(self, componentClass)
	local component = componentClass()
	if not component:isKindOf(Component) then
		return
	end
	local componentName = (component:isKindOf(Behaviour) and 'behaviour') or (component:isKindOf(Renderer) and 'renderer') or firstCharacterLowercase(componentClass.className)
	self._components[componentName] = component
	component:setEntity(self)
	component:setTransform(self._components.transform)
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
	if self:getScene() then
		self:getScene():resetDelegates(entity)
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
	if self:getScene() then
		self:getScene():removeDelegates(entity)
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