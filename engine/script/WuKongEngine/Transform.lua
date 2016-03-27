local Class = require('Class')
local Component = require('Component')
local Vector3 = require('Vector3')
local Matrix3 = require('Matrix3')

local modName = ...

local Transform = Class(modName, Component, false)

local math = math
local print = print

_G[modName] = Transform
package.loaded[modName] = Transform

local _ENV = Transform

function init(self)
	super.init(self)
	self._positionIsDirty = true
	self._position = Vector3(0, 0, 0)
	self._localPosition = Vector3(0, 0, 0)
	self._localScale = Vector3(1, 1, 1)
	self._localRotation = 0
	self._isDirty = true
	self._localToWorldMatrix = Matrix3.identity:clone()
	self._isInverseDirty = true
	self._worldToLocalMatrix = Matrix3.identity:clone()

end

function setParent(self, transform)
	self._parent = transform
	self:setLocalPosition(self:getPosition().x - transform:getPosition().x, self:getPosition().y - transform:getPosition().y)
end

function setDirty(self)
	if not self._isDirty then
		self._isDirty = true
		self._isInverseDirty = true
		self.entity:enumerate(function(entity)
			local transform = entity:getTransform()
			transform:setDirty()
			return true
		end)
	end
end

function getPosition(self)
	if self._positionIsDirty then 
		self._position = self:transformPoint(0, 0)
		self._positionIsDirty = false
	end
	return self._position
end

function setPosition(self, x, y)
	self._position = Vector3(x, y, 0)
	self._positionIsDirty = false
	if not self._parent then
		self._localPosition = self._position:clone()
	else
		self._localPosition = self._parent:inverseTransformPoint(x, y)
	end
	self:setDirty()
end

function getLocalPosition(self)
	return self._localPosition
end

function setLocalPosition(self, x, y)
	self._localPosition = Vector3(x, y, 0)
	self._positionIsDirty = true
	self:setDirty()
end

function getLocalRotation(self)
	return self._localRotation
end

function setLocalRotation(self, angle)
	self._localRotation = angle * math.pi / 180
	self:setDirty()
end

function getLocalScale(self)
	return self._localScale
end

function  setLocalScale(self, x, y)
	self._localScale = Vector3(x, y, 1)
	self:setDirty()
end

function calclateLocalToParentMatrix(self)
	return Matrix3.translate(self._localPosition.x, self._localPosition.y) * Matrix3.rotate(self._localRotation) * Matrix3.scale(self._localScale.x, self._localScale.y)
end

function getLocalToWorldMatrix(self)
	if self._isDirty then
		if self._parent then
			self._localToWorldMatrix = self._parent:getLocalToWorldMatrix() * self:calclateLocalToParentMatrix()
		else
			self._localToWorldMatrix = self:calclateLocalToParentMatrix()
		end
		self._isDirty = false
	end
	return self._localToWorldMatrix
end

function getWorldToLocalMatrix(self)
	if self._isInverseDirty then
		self._worldToLocalMatrix = self:getLocalToWorldMatrix():inverse()
		self._isInverseDirty = false
	end
	return self._worldToLocalMatrix
end

function translate(self, dx, dy)
	local localPosition = self:getLocalPosition()
	self:setLocalPosition(localPosition.x + dx, localPosition.y + dy)
	self:setDirty()
end

function rotate(self, angle, relateToSelf)
	local rad = angle * math.pi / 180
	if relateToSelf then
		self._localRotation = self._localRotation + rad
	else
		local cos = math.cos(rad)
		local sin = math.sin(rad)
		local localPosition = self:getLocalPosition()
		--print('at rotate', localPosition.x, localPosition.y)
		self:translate(localPosition.x * cos - localPosition.y * sin - localPosition.x, 
					   localPosition.x * sin + localPosition.y * cos - localPosition.y)
	end
	self:setDirty()
end

function scale(self, sx, sy, relateToSelf)
	if relateToSelf then
		self._localScale = self._localScale:mul(sx, sy, 1)
	else
		local localPosition = self:getLocalPosition()
		self:translate(sx * localPosition.x - localPosition.x, sy * ocalPosition.y - localPosition.y)
	end
	self:setDirty()
end

function transformPoint(self, x, y)
	local localToWorldMatrix = self:getLocalToWorldMatrix()
	--print(localToWorldMatrix:toString())
	return Vector3(localToWorldMatrix[1][1] * x + localToWorldMatrix[1][2] * y + localToWorldMatrix[1][3], 
					localToWorldMatrix[2][1] * x + localToWorldMatrix[2][2] * y + localToWorldMatrix[2][3],
					0)
end

function inverseTransformPoint(self, x, y)
	local worldToLocalMatrix = self:getWorldToLocalMatrix()
	return Vector3(worldToLocalMatrix[1][1] * x + worldToLocalMatrix[1][2] * y + worldToLocalMatrix[1][3], 
					worldToLocalMatrix[2][1] * x + worldToLocalMatrix[2][2] * y + worldToLocalMatrix[2][3],
					0)
end