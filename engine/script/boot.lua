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
local Image = require('SDL.image')

math.randomseed(os.time())

Image.init({PNG = 1})

local renderer = runtime._renderer
--print(runtime['_scriptDirectory'])
--print(runtime.messageloop)

for file in lfs.dir(runtime['_serviceDirectory']) do
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
	Runtime._services[serviceName] = Service()
end

function Runtime.startAllServices()
	for file in lfs.dir(Runtime['_serviceDirectory']) do
		local  i, j = string.find(file, '%a+Service.lua')
		if i then
			local serviceName = string.sub(file, i, j - 4);
			Runtime.loadServic(serviceName)
		end
	end
	for name, service in pairs(runtime._services) do
		service:start()
	end
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

function trace (event, line)
      local s = debug.getinfo(2).short_src
      print(s .. ":" .. line)
end
    
--debug.sethook(trace, "l")

local WukongEngine = require('WukongEngine')
_G.WukongEngine = WukongEngine()

local main = loadfile(Runtime._scriptDirectory .. '/main.lua')

main()

--[[

function doPenddingWorks()
	local penddingWorks = runtime.penddingWorks;
	runtime.penddingWorks = {}
	for i, work in ipairs(penddingWorks) do
		work()
	end
end

local lastUpdateTime = time.now()

local tick = 1 / 60

function render()
	
end


bmp = Image.load('stroke.bmp') --SDL.loadBMP('stroke.bmp')
brush = renderer:createTextureFromSurface(bmp)
brush:setBlendMode(SDL.blendMode.Add)
brush:setColorMod({r = 255, g = 100, b = 100})
renderer:setDrawColor({r = 0, g = 0, b = 0, a = 255})
renderer:clear()
renderer:present()

function drawLine(startx, starty, dx, dy)
	local distance = math.sqrt(dx * dx + dy * dy)
	--print('distance: ', distance)
	local iterations = distance / 5 + 1
	local dxPrime = dx / iterations
	local dyPrime = dy / iterations
	local dstRect = {x = 0, y = 0, w = 32, h = 32}
	local x = startx - 32 / 2
	local y = starty - 32 / 2
	for i = 1, iterations, 1 do
		dstRect.x = math.floor(x)
		dstRect.y = math.floor(y)
		x = x + dxPrime
		y = y + dyPrime
		--print('draw: ', dstRect.x, ' ', dstRect.y)
		renderer:copy(brush, nil, dstRect)
	end
end



function update()
	local now = time.now()
	local deltaTime = now - lastUpdateTime
	time.deltaTime = deltaTime
	lastUpdateTime = now
	for e in SDL.pollEvent() do
		if e and e.type == SDL.event.MouseMotion then
			local state, x, y = SDL.getMouseState()
			local _, dx, dy = SDL.getRelativeMouseState()
			if state[SDL.mouseMask.Left] then
				drawLine(x - dx, y - dy, dx, dy)
				renderer:present()
			end
		end
	end
	for _, service in pairs(runtime._services) do
			service:update()
	end
	doPenddingWorks()
	render()
	now = time.now()
	deltaTime = now - lastUpdateTime
	if deltaTime > tick then
		return update()
	else
		return messageloop.postDelayTask(update, tick - deltaTime)
	end
end

update()

]]--



