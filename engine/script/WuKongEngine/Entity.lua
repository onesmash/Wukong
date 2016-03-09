local Class = require('Class')
local GameObject = require('GameObject')
local Transform = require('Transform')
local Component = require('Component')
local Behaviour = require('Behaviour')

local modName = ...

local Entity = Class(modName, GameObject, false)

_G[modName] = Entity
package.loaded[modName] = Entity

local string = string
local table = table
local ipairs = ipairs

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

function addComponent(self, componentClass)
	local component = componentClass()
	if not component:isKindOf(Component) then
		return
	end
	local componentName = (component:isKindOf(Behaviour) and 'behaviour') or firstCharacterLowercase(componentClass.className)
	self._components[componentName] = component
	component.entity = self
	component.transform = self._components.transform
end

function getComponent(self, componentClass)
	local componentName = firstCharacterLowercase(componentClass.className)
	return self._components[componentName]
end

function addChild(self, entity)
	table.insert(self._children, entity)
	entity._parent = self
	local transform = entity:getComponent(Transform)
	transform:setParent(self.transform)
end

function enumerate(self, f)
	f(self)
	for _, entity in ipairs(self._children) do
		entity:enumerate(f)
	end
end