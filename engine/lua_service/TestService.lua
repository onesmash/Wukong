local Service = require('Service')
local time = require('runtime.time')
local modName = ...

local TestService = Class(modName, Service)

_G[modName] = TestService
package.loaded[modName] = TestService

local print = print

local type =  type

local _ENV = TestService

private.x = modName

function init(self, f)
	super.init(self)
end

function start(self)
	-- body
	print('TestService start')
end

function update(self)
	-- body
	--print(_ENV)
	--print('update ' .. time.deltaTime)
end