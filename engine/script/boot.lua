local runtime = require('runtime')
runtime._services = {}
runtime.penddingWorks = {}

function runtime.scheduleWork(work)
	table.insert(runtime.penddingWorks, work)
end

local lfs = require('lfs')
local messageloop = require('runtime.messageloop')
local time = require('runtime.time')
package.path = package.path .. ';' .. runtime._scriptDirectory .. '/?.lua'
local Coroutine = require('Coroutine')
local Continuation = require('Continuation')
local SDL = require('SDL')
local Image = require('SDL.image')
local WukongEngine = require('WukongEngine')

Image.init({PNG = 1})

local renderer = runtime._renderer
--print(runtime['_scriptDirectory'])
--print(runtime.messageloop)

for file in lfs.dir(runtime['_serviceDirectory']) do
--file is the current file or directory name
--print( "Found file: " .. file )
end

function runtime.printTable(t)
	print('{')
	for k, v in pairs(t) do
		print(k .. ' ' .. v)
	end
	print('}')
end

function runtime.startCoroutine(f, ...)
	local co = Coroutine(f)
	co:resume(...)
	return co
end

function runtime.callCC(f)
	local continuation = Continuation(f)
	return coroutine.yield(continuation)
end

function runtime.waitForCoroutine(co)
	runtime.callCC(function(continuation)
		if co:status() == 'dead' then
			continuation()
		else
			co:addObserver('dead', continuation)
		end
	end)
end

function runtime.waitForSeconds(seconds)
	runtime.callCC(function(continuation)
		messageloop.postDelayTask(continuation, seconds)
	end)
end

function runtime.loadServic(serviceName)
	local Service = require(serviceName)
	runtime._services[serviceName] = Service()
end

function runtime.startAllServices()
	for file in lfs.dir(runtime['_serviceDirectory']) do
		local  i, j = string.find(file, '%a+Service.lua')
		if i then
			local serviceName = string.sub(file, i, j - 4);
			runtime.loadServic(serviceName)
		end
	end
	for name, service in pairs(runtime._services) do
		service:start()
	end
end

runtime.startAllServices()

local co0 = runtime.startCoroutine(function()
	print('start wait0 ' .. os.date())
	runtime.waitForSeconds(5)
	print('end wait0 ' .. os.date())
	coroutine.yield(1)
	print('end co0')
end)

local co1 = runtime.startCoroutine(function()
	print('start wait1 ' .. os.date())
	runtime.waitForSeconds(2)
	print('end wait1 ' .. os.date())
	runtime.waitForCoroutine(co0)
	print('end co1')
end)

wukongEngine = WukongEngine()

local main = loadfile(runtime._scriptDirectory .. '/main.lua')

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



