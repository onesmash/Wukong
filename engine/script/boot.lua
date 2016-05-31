local Runtime = require('runtime')
Runtime._services = {}
Runtime.penddingWorks = {}

function Runtime.scheduleWork(work)
	table.insert(Runtime.penddingWorks, work)
end

local lfs = require('lfs')
local messageloop = require('runtime.messageloop')
local time = require('runtime.time')
package.path = package.path .. ';' .. Runtime._scriptDirectory .. '/?.lua'
local Coroutine = require('Coroutine')
local Continuation = require('Continuation')
local SDL = require('SDL')

math.randomseed(os.time())

for file in lfs.dir(Runtime['_serviceDirectory']) do
 	--file is the current file or directory name
	--print( "Found file: " .. file )
end

function Runtime.printTable(t)
	print('{')
	for k, v in pairs(t) do
		print(k .. ' ' .. v)
	end
	print('}')
end

function Runtime.startCoroutine(f, ...)
	local co = Coroutine(f)
	co:resume(...)
	return co
end

function Runtime.callCC(f)
	local continuation = Continuation(f)
	return coroutine.yield(continuation)
end

function Runtime.waitForCoroutine(co)
	Runtime.callCC(function(continuation)
		if co:status() == 'dead' then
			continuation()
		else
			co:addObserver('dead', continuation)
		end
	end)
end

function Runtime.waitForSeconds(seconds)
	Runtime.callCC(function(continuation)
		messageloop.postDelayTask(continuation, seconds)
	end)
end

function Runtime.loadServic(serviceName)
	local Service = require(serviceName)
	Runtime._services[Service] = Service()
end

function Runtime.startAllServices()
	for file in lfs.dir(Runtime['_serviceDirectory']) do
		local  i, j = string.find(file, '%a+Service.lua')
		if i then
			local serviceName = string.sub(file, i, j - 4);
			Runtime.loadServic(serviceName)
		end
	end
	for name, service in pairs(Runtime._services) do
		service:start()
	end
end

function Runtime.getService(service)
	return Runtime._services[service]
end

Runtime.startAllServices()

local co0 = Runtime.startCoroutine(function()
	print('start wait0 ' .. os.date())
	Runtime.waitForSeconds(5)
	print('end wait0 ' .. os.date())
	coroutine.yield(1)
	print('end co0')
end)

local co1 = Runtime.startCoroutine(function()
	print('start wait1 ' .. os.date())
	Runtime.waitForSeconds(2)
	print('end wait1 ' .. os.date())
	Runtime.waitForCoroutine(co0)
	print('end co1')
end)

Runtime.Device = {}
Runtime.Device.displayInfo = {}
local sdlDisplayMode = SDL.getCurrentDisplayMode(0)
Runtime.Device.displayInfo.w = sdlDisplayMode.w
Runtime.Device.displayInfo.h = sdlDisplayMode.h
Runtime.Device.displayInfo.refreshRate = sdlDisplayMode.refreshRate or 60

local WukongEngine = require('WukongEngine')
_G.WukongEngine = WukongEngine()

local main = loadfile(Runtime._scriptDirectory .. '/main.lua')

main()

