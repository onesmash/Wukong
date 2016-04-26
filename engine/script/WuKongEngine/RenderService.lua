local Service = require('Service')
local Runtime = require('runtime')
local render = require('runtime.render')
local modName = ...

local RenderService = Class(modName, Service)

_G[modName] = RenderService
package.loaded[modName] = RenderService

local print = print

local type =  type

local table = table

local _ENV = RenderService

function init(self, f)
	super.init(self)
end

function start(self)
	-- body
	--print('RenderService start')
	render.start(Runtime._window, Runtime._context, Runtime._renderer)
end

function renderBegin(self)
	render.renderBegin()
end

function renderEnd(self)
	render.renderEnd()
end

function clear(self, color)
	render.clear(color)
end

function draw(self, texture, srcRect, dstRect, angle, center)
	render.draw(texture, srcRect, dstRect, angle, center)
end

function drawRect(self, color, rect)
	render.drawRect(color, rect)
end

function present(self)
	render.present()
end