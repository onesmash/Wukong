local Class = require('Class')
local Object = require('Object')

local modName = ...

local Vector3 = Class(modName, Object, false)

_G[modName] = Vector3
package.loaded[modName] = Vector3

local _ENV = Vector3

function init(self, x, y, z)
	super.init(self)
	self.x = x
	self.y = y
	self.z = z or 0
end

function add(self, x, y, z)
	self.x = self.x + x
	self.y = self.y + y
	self.z = self.z + z
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

function clone(self)
	local vector = super.clone(self)
	vector.x = self.x
	vector.y = self.y
	vector.z = self.z
	return vector
end