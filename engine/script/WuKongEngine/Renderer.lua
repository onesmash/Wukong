local Class = require('Class')
local Component = require('Component')

local modName = ...

local Renderer = Class(modName, Component, false)

_G[modName] = Renderer
package.loaded[modName] = Renderer

local string = string

local _ENV = Renderer

function init(self)
	self = super.init(self)
end