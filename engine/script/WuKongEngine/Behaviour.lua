local Class = require('Class')
local Component = require('Component')

local modName = ...

local Behaviour = Class(modName, Component, true)

_G[modName] = Behaviour
package.loaded[modName] = Behaviour

local print = print
local yield = coroutine.yield
local setmetatable = setmetatable
local table = table

local _ENV = Behaviour

function init(self, f)
	super.init(self)
	self._coroutines = {}
	setmetatable(self._coroutines, {__mode = 'v'})
end

function start(self)
	-- body
end

--function update(self)
	-- body
--end

function startCoroutine(self, f)
	local co = runtime.startCoroutine(f)
	local coroutines = self._coroutines
	table.insert(coroutines, co)
	return co
end

function stopCoroutine(self, co)
	co:stop()
	local coroutines = self._coroutines
	table.remove(coroutines, co)
end

function stopAllCoroutine(self)
	for _, co in pairs(self._coroutines) do
		self:stopCoroutine(co)
	end
end

function finalize(self)
	print('finalize ' .. modName)
end