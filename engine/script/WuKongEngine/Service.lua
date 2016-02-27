local Class = require('Class')
local Object = require('Object')
local runtime = require('runtime')

local modName = ...

local Service = Class(modName, Object, true)
local time = require('runtime.time')

_G[modName] = Service
package.loaded[modName] = Service

local print = print
local callCC = runtime.callCC
local yield = coroutine.yield
local setmetatable = setmetatable

local _ENV = Service 

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

function unload(self)
	-- body
end

function startCoroutine(self, f)
	local co = runtime.startCoroutine(f)
	local coroutines = self.coroutines
	coroutines[#coroutines + 1] = co
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