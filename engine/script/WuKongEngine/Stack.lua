local Class = require('Class')
local Object = require('Object')

local modName = ...

local Stack = Class(modName, Object, false)

_G[modName] = Stack
package.loaded[modName] = Stack

local table = table
local print = print

local _ENV = Stack

function init(self)
	self._container = {}
end

function push(self, item)
	table.insert(self._container, item)
end

function pop(self)
	local item = self._container[#self._container]
	table.remove(self._container, #self._container)
	return item
end

function size(self)
	return #self._container
end