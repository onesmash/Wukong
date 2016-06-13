local Class = require('Class')
local Behaviour = require('Behaviour')
local Renderer = require('Renderer')

local modName = ...

local UIBehaviour = Class(modName, Behaviour, false)

_G[modName] = UIBehaviour
package.loaded[modName] = UIBehaviour

local print = print

local _ENV = UIBehaviour

function init(self)
	super.init(self)
end

function hitTest(self, point)
	if self.entity:pointInside(point) then
		for _, entity in ipairs(self._children) do
			local view = entity:hitTest(point)
			if view then
				return view
			end
		end
	end
	return nil
end

function pointInside(self, point)
	local localPosition = self.transform:inverseTransformPoint(point.x, point.y)
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