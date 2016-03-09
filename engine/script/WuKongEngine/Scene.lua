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
	local mt = {__mode = 'v'}
	self._start = {}
	setmetatable(self._start, mt)
	self._update = {}
	setmetatable(self._update, mt)
	self._render = {}
	setmetatable(self._render, mt)
end

function addEntity(self, entity)
	entity.scene = self
	table.insert(self._entities, entity)
	entity:enumerate(function(entity)
		local behaviour = entity:getComponent(Behaviour)
		if type(behaviour.start) == 'function' then
			table.insert(self._start, behaviour)
		end
		if type(behaviour.update) == 'function' then
			table.insert(self._update, behaviour)
		end
		local renderer = entity:getComponent(Renderer)
		if renderer then
			local layer = self._render[renderer.sortingLayer] or {}
			local renderers = layer[renderer.sortingOrder] or {}
			table.insert(renderers, renderer)
			layer[renderer.sortingOrder] = renderers
			self._render[renderer.sortingLayer] = layer
		end
	end)
end

function onLoad(self)
	for _, behaviour in ipairs(self._start) do
		behaviour:start()
	end
end

function onUpdate(self)
	for _, behaviour in ipairs(self._update) do
		behaviour:update()
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

function onRender(self)
	local keys = sortedTableKeys(self._render)
	for _, sortingLayer in ipairs(keys) do
		local layer = self._render[sortingLayer]
		local keys = sortedTableKeys(layer)
		for _, sortingOrder in ipairs(keys) do
			local renderers = layer[sortingOrder]
			for _, renderer in ipairs(renderers) do
				renderer:render()
			end
		end
	end
	Renderer.present()
end