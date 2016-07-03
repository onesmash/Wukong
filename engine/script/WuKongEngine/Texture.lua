local Class = require('Class')
local GameObject = require('GameObject')
local runtime = require('runtime')
local SDL = require('SDL')
local Image = require('SDL.image')
local Renderer = require('Renderer')
local CTexture = require('runtime.Texture.c')

--local renderer = runtime._renderer

local modName = ...

local Texture = Class(modName, GameObject, true)

_G[modName] = Texture
package.loaded[modName] = Texture

local print = print

local _ENV = Texture

function new(class)
	return CTexture.new(class)
end

function init(self, width, height)
	super.init(self)
	self.width = width
	self.height = height
end

function loadImage(self, filePath)
	CTexture.loadImage(self, Renderer.platformRenderer, filePath)
	local w, h = CTexture.size(self)
	--local image = Image.load(filePath)
	--self._sdltexture = renderer:createTextureFromSurface(image)
	--self._sdltexture:setBlendMode(SDL.blendMode.Blend)
	--local format, access, w, h, error = self._sdltexture:query()
	self.width = w or 0
	self.height = h or 0
	self._imagePath = filePath
end

function loadCanvas(self, canvas)
	CTexture.loadCanvas(self, Renderer.platformRenderer, canvas)
	self.width = canvas.width
	self.height = canvas.height
end

function finalize(self)
	--print(self._imagePath)
end