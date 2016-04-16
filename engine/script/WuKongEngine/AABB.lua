local Class = require('Class')
local Object = require('Object')
local Vector3 = require('Vector3')

local modName = ...

local AABB = Class(modName, Object, false)

_G[modName] = AABB
package.loaded[modName] = AABB

local print = print

local _ENV = AABB

static.extension = 10
static.multiplier = 2

function static.testOverlap(aabb1, aabb2)
	local d1 = aabb2.lowerBound - aabb1.upperBound
	local d2 = aabb1.lowerBound - aabb2.upperBound

	if d1.x > 0 or d1.y > 0 then
		return false
	end

	if d2.x > 0 or d2.y > 0 then
		return false
	end

	return true
end

function static.combine(aabb1, aabb2)
	local lowerBound = Vector3.min(aabb1.lowerBound, aabb2.lowerBound)
	local upperBound = Vector3.max(aabb1.upperBound, aabb2.upperBound)
	return AABB(lowerBound, upperBound)
end

function init(self, lowerBound, upperBound)
	super.init(self)
	self.lowerBound = lowerBound or Vector3()
	self.upperBound = upperBound or Vector3()
end

function getCenter(self)
	return (self.lowerBound + self.upperBound):mul(0.5, 0.5, 0.5)
end

function getExtents(self)
	return (self.upperBound - self.lowerBound):mul(0.5, 0.5, 0.5)
end

function getPerimeter(self)
	local w = self.upperBound.x - self.lowerBound.x
	local h = self.upperBound.y - self.lowerBound.y
	return 2 * (w + h)
end

function combine(self, aabb)
	self.lowerBound = Vector3.min(self.lowerBound, aabb.lowerBound)
	self.upperBound = Vector3.max(self.upperBound, aabb.upperBound)
	return self
end

function combine2AABB(self, aabbA, aabbB)
	self.lowerBound = Vector3.min(aabbA.lowerBound, aabbB.lowerBound)
	self.upperBound = Vector3.max(aabbA.upperBound, aabbB.upperBound)
	return self
end

function contains(self, aabb)
	local result = true
	result = result and self.lowerBound.x <= aabb.lowerBound.x
	result = result and self.lowerBound.y <= aabb.lowerBound.y
	result = result and aabb.upperBound.x <= self.upperBound.x
	result = result and aabb.upperBound.y <= self.upperBound.y
	return result
end

function clone(self)
	local lowerBound = self.lowerBound:clone()
	local upperBound = self.upperBound:clone()
	return AABB(lowerBound, upperBound)
end