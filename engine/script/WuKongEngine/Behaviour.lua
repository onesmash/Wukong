local Class = require('Class')
local Component = require('Component')

local modName = ...

local Behaviour = Class(modName, Component, true)

_G[modName] = Behaviour
package.loaded[modName] = Behaviour

local print = print
local callCC = runtime.callCC
local yield = coroutine.yield
local setmetatable = setmetatable
local table = table

local _ENV = Behaviour

callCC = callCC
yield = yield

function init(self, f)
	super.init(self)
	self.coroutines = {}
	setmetatable(self.coroutines, {__mode = 'v'})
end

function start(self)
	-- body
end

function update(self)
	-- body
end

function startCoroutine(self, f)
	local co = runtime.startCoroutine(f)
	local coroutines = self.coroutines
	table.insert(coroutines, co)
end

function stopCoroutine(self, co)
	-- body
end

function stopAllCoroutine(self)
	-- body
end

function finalize(self)
	print('finalize ' .. modName)
end