local Class = require('Class')
local GameObject = require('GameObject')
local runtime = require('runtime')
local SDL = require('SDL')
local Image = require('SDL.image')

local renderer = runtime._renderer

local modName = ...

local Texture = Class(modName, GameObject, false)

_G[modName] = Texture
package.loaded[modName] = Texture

local print = print

local _ENV = Texture

function init(self, width, height)
	super.init(self)
	self.width = width
	self.height = height
end

function loadImage(self, filePath)
	local image = Image.load(filePath)
	self._sdltexture = renderer:createTextureFromSurface(image)
	self._sdltexture:setBlendMode(SDL.blendMode.Blend)
	local format, access, w, h, error = self._sdltexture:query()
	self.width = w or 0
	self.height = h or 0
end