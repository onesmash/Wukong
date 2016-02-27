local Class = require('Class')
local Object = require('Object')
local Continuation = require('Continuation')
local runtime = require('runtime')

local modName = ...

local Coroutine = Class(modName, Object)

local coroutine = coroutine
local type = type
local print = print
local type = type
local ipairs = ipairs

_G[modName] = Coroutine
package.loaded[modName] = Coroutine

local _ENV = Coroutine


function init(self, f)
	super.init(self)
	local co = coroutine.create(f)
	self.co = co
	self.observers = {}
end

function resume(self)
	if self:status() ~= 'dead' then
		local status, continuation = coroutine.resume(self.co)
		if type(continuation) == 'object' and continuation:isKindOf(Continuation) then
			local call = continuation.c
			local CC = function(...)
				local params = ...
				runtime.scheduleWork(function()
					self:resume(params)
				end)
			end
			call(CC)
		else
			runtime.scheduleWork(function()
				self:resume()
			end)
		end
		if self:status() == 'dead' then
			local deadObservers = self.observers['dead'] or {}
			for i, observer in ipairs(deadObservers) do
				observer()
			end
		end
		print(coroutine.status(self.co))
	end
end

function status(self)
	return coroutine.status(self.co)
end

function addObserver(self, observerType, f)
	if not self.observers[observerType] then
		self.observers[observerType] = {}
	end
	local observers = self.observers[observerType]
	observers[#observers + 1] = f
end