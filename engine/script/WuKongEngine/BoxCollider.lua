local Class = require('Class')
local Component = require('Component')
local Collider = require('Collider')
local Vector3 = require('Vector3')

local modName = ...

local BoxCollider = Class(modName, Collider, false)

_G[modName] = BoxCollider
package.loaded[modName] = BoxCollider

local ipairs = ipairs
local print = print

_ENV = BoxCollider

function init(self)
	super.init(self)
end

function getVertices(self)
	local transform = self.transform
	local centerLeftWidth = self.width * self.center.x
	local centerBottomHeight = self.height * self.center.y

	local localTopLeft = Vector3(-centerLeftWidth, self.height - centerBottomHeight, 0)
	local localTopRight = Vector3(self.width - centerLeftWidth, self.height - centerBottomHeight, 0)
	local localBottomLeft = Vector3(-centerLeftWidth, -centerBottomHeight, 0)
	local localBottomRight = Vector3(self.width - centerLeftWidth, - centerBottomHeight, 0)

	local topLeft = transform:transformPoint(localTopLeft.x, localTopLeft.y)
	local topRight = transform:transformPoint(localTopRight.x, localTopRight.y)
	local bottomLeft = transform:transformPoint(localBottomLeft.x, localBottomLeft.y)
	local bottomRight = transform:transformPoint(localBottomRight.x, localBottomRight.y)
	return {bottomLeft, topLeft, topRight, bottomRight}
end

function getAxisAndVertices(self)
	local vertices = self:getVertices()
	local edge1 = vertices[2] - vertices[1]
	local edge1SquaredLength = edge1:squaredLength()
	edge1:div(edge1SquaredLength, edge1SquaredLength, edge1SquaredLength)
	local edge2 = vertices[4] - vertices[1]
	local edge2SquaredLength = edge2:squaredLength()
	edge2:div(edge2SquaredLength, edge2SquaredLength, edge2SquaredLength)
	--print(edge1.x, edge1.y)
	--print(edge2.x, edge2.y)
	return {edge1, edge2}, vertices
end

function testOBBOBB(self, collider)
	local myAxis, myVertices = self:getAxisAndVertices()
	local otherAxis, otherVertices = collider:getAxisAndVertices()

	for _, axis in ipairs(myAxis) do
		local min = otherVertices[1]:dot(axis)
		local max = min
		for i = 2, #otherVertices do
			local p = otherVertices[i]:dot(axis)
			if p < min then
				min = p
			elseif p > max then
				max = p
			end
		end
		local origin = myVertices[1]:dot(axis)
		--print(min, max, origin)
		if min > 1 + origin or max < origin then
			return false
		end
	end

	for _, axis in ipairs(otherAxis) do
		local min = myVertices[1]:dot(axis)
		local max = min
		for i = 2, #myVertices do
			local p = myVertices[i]:dot(axis)
			if p < min then
				min = p
			elseif p > max then
				max = p
			end
		end
		local origin = otherVertices[1]:dot(axis)
		--print(min, max, origin)
		if min > 1 + origin or max < origin then
			return false
		end
	end

	return true
end

function testCollide(self, collider)
	if self.enabled and collider:isKindOf(BoxCollider) then
		return self:testOBBOBB(collider)
	else
		return false
	end 
end
