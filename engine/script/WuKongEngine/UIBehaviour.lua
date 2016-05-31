local Class = require('Class')
local Behaviour = require('Behaviour')
local Renderer = require('Renderer')

local modName = ...

local UIBehaviour = Class(modName, Behaviour, false)

_G[modName] = UIBehaviour
package.loaded[modName] = UIBehaviour

local _ENV = UIBehaviour

function init(self)
	super.init(self)
end

function hitTest(self, position)
	local localPosition = self.transform:inverseTransformPoint(position.x, position.y)
	local renderer = self.entity:getComponent(Renderer)
	local canvas = renderer.canvas
	local lowerX = -canvas.width * canvas.center.x
	local lowerY = -canvas.height * canvas.center.y
	local upperX = canvas.width * (1 - canvas.center.x)
	local upperY = canvas.height * (1- canvas.center.y)
	local result = true
	result = result and lowerX <= localPosition.x
	result = result and lowerY <= localPosition.y
	result = result and localPosition.x <= upperX
	result = result and localPosition.y <= upperY
	return result
end