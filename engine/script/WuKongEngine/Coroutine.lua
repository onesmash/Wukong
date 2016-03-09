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
local table = table

_G[modName] = Coroutine
package.loaded[modName] = Coroutine

local _ENV = Coroutine

function static.waitForSeconds(seconds)
	runtime.waitForSeconds(seconds)
end

function init(self, f)
	super.init(self)
	local co = coroutine.create(f)
	self._co = co
	self._observers = {}
	self._status = coroutine.status(self._co)
end

function resume(self)
	if self:status() ~= 'dead' then
		local status, continuation = coroutine.resume(self._co)
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
		self._status = coroutine.status(self._co)
		if self:status() == 'dead' then
			local deadObservers = self._observers['dead'] or {}
			for _, observer in ipairs(deadObservers) do
				observer()
			end
		end
		print(coroutine.status(self._co))
	end
end

function status(self)
	return self._status
end

function stop(self)
	self._status = 'dead'
	local deadObservers = self._observers['dead'] or {}
	for _, observer in ipairs(deadObservers) do
		observer()
	end
end

function addObserver(self, observerType, f)
	if not self._observers[observerType] then
		self._observers[observerType] = {}
	end
	local observers = self._observers[observerType]
	table.insert(observers, f)
end