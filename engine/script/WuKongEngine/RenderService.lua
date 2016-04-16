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
	self._buffer = {}
	self._renderCount = 0
end

function start(self)
	-- body
	--print('RenderService start')
	render.start(Runtime.__window, Runtime.__context, Runtime.__renderer)
end

function renderBegin(self)
	self._renderCount = self._renderCount + 1
	render.renderBegin()
end

function renderEnd(self)
	render.renderEnd(function()
		self._renderCount = self._renderCount - 1
		if self._renderCount <= 0 then
			self._buffer = {}
		end
	end)
end

function clear(self, color)
	render.clear(color)
end

function draw(self, texture, srcRect, dstRect, angle, center)
	self._buffer[texture] = 1
	render.draw(texture._sdltexture, srcRect, dstRect, angle, center)
end

function drawRect(self, color, rect)
	render.drawRect(color, rect)
end

function present(self)
	render.present()
end