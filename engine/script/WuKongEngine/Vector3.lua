local Class = require('Class')
local Object = require('Object')

local modName = ...

local Vector3 = Class(modName, Object, false)

_G[modName] = Vector3
package.loaded[modName] = Vector3

local math = math

local _ENV = Vector3

local floatEpsilon = 1.1920928955078125e-07
local doubleEpsilon = 2.22044604925031308e-16

function __add(left, right)
	return Vector3(left.x + right.x, left.y + right.y, left.z + right.z)
end

function __sub(left, right)
	return Vector3(left.x - right.x, left.y - right.y, left.z - right.z)
end

function __mul(left, right)
	return Vector3(left.x * right.x, left.y * right.y, left.z * right.z)
end

function static.min(a, b)
	return Vector3(math.min(a.x, b.x), math.min(a.y, b.y), math.min(a.z, b.z))
end

function static.max(a, b)
	return Vector3(math.max(a.x, b.x), math.max(a.y, b.y), math.max(a.z, b.z))
end

function static.abs(v)
	return Vector3(math.abs(v.x), math.abs(v.y), math.abs(v.z))
end

function init(self, x, y, z)
	super.init(self)
	self.x = x or 0
	self.y = y or 0
	self.z = z or 0
end

function add(self, x, y, x)
	self.x = self.x + x
	self.y = self.y + y
	self.z = self.z + z
	return self
end

function sub(self, x, y, z)
	self.x = self.x - x
	self.y = self.y - y
	self.z = self.z - z
	return self
end

function mul(self, x, y, z)
	self.x = self.x * x
	self.y = self.y * y
	self.z = self.z * z
	return self
end

function div(self, x, y, z)
	self.x = self.x / x
	self.y = self.y / y
	self.z = self.z / z
	return self
end

function length(self)
	return math.sqrt(self.x * self.x + self.y * self.y + self.x * self.z)
end

function squaredLength(self)
	return self.x * self.x + self.y * self.y + self.x * self.z
end

function normalize(self)
	local length = self:length()
	if length < floatEpsilon then
		return 0
	end
	local invLength = 1 / length
	self.x = self.x * invLength
	self.y = self.y * invLength
	self.z = self.z * invLength
	return length
end

function dot(self, v)
	return self.x * v.x + self.y * v.y + self.z * v.z
end

function clone(self)
	local vector = super.clone(self)
	vector.x = self.x
	vector.y = self.y
	vector.z = self.z
	return vector
end