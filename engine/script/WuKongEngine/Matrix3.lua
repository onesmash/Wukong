local Class = require('Class')
local Object = require('Object')

local modName = ...

local Matrix3 = Class(modName, Object, false)

Matrix3.__mul = function(left, right)
	local row1 = { left[1][1] * right[1][1] + left[1][2] * right[2][1] + left[1][3] * right[3][1],
				   left[1][1] * right[1][2] + left[1][2] * right[2][2] + left[1][3] * right[3][2],
				   left[1][1] * right[1][3] + left[1][2] * right[2][3] + left[1][3] * right[3][3]}

	local row2 = { left[2][1] * right[1][1] + left[2][2] * right[2][1] + left[2][3] * right[3][1],
				   left[2][1] * right[1][2] + left[2][2] * right[2][2] + left[2][3] * right[3][2],
				   left[2][1] * right[1][3] + left[2][2] * right[2][3] + left[2][3] * right[3][3]}
	local row3 = { left[3][1] * right[1][1] + left[3][2] * right[2][1] + left[3][3] * right[3][1],
				   left[3][1] * right[1][2] + left[3][2] * right[2][2] + left[3][3] * right[3][2],
				   left[3][1] * right[1][3] + left[3][2] * right[2][3] + left[3][3] * right[3][3]}
	local matrix = Matrix3(row1, row2, row3)
	return matrix
end

_G[modName] = Matrix3
package.loaded[modName] = Matrix3

local print = print
local pairs = pairs
local math = math
local type = type
local string = string
local _ENV = Matrix3

function static.translate(x, y)
	return Matrix3( {1, 0, x}, 
					{0, 1, y},
					{0,	0, 1})
end

function static.rotate(rad)
	local cos = math.cos(rad)
	local sin = math.sin(rad)
	return Matrix3( {cos, sin, 0},
					{sin, cos, 0},
					{  0,   0, 1})
end

function static.scale(x, y)
	return Matrix3( {x, 0, 0},
					{0, y, 0},
					{0, 0, 1})
end

function init(self, row1, row2, row3)
	super.init(self)
	self[1] = row1
	self[2] = row2
	self[3] = row3
end

static.identity = Matrix3({1, 0, 0}, {0, 1, 0}, {0, 0, 1})

function inverse(self)
	local det = self[1][1] * self[2][2] * self[3][3] - 
				self[1][1] * self[2][3] * self[3][2] -
				self[1][2] * self[2][1] * self[3][3] +
				self[1][2] * self[2][3] * self[3][1] +
				self[1][3] * self[2][1] * self[3][2] -
				self[1][3] * self[2][2] * self[3][1]
	local row1 = {(self[2][2] * self[3][3] - self[2][3] * self[3][2]) / det, 
				  (self[1][3] * self[3][2] - self[1][2] * self[3][3]) / det, 
				  (self[1][2] * self[2][3] - self[1][3] * self[2][2]) / det}
	local row2 = {(self[2][3] * self[3][1] - self[2][1] * self[3][3]) / det, 
				  (self[1][1] * self[3][3] - self[1][3] * self[3][1]) / det, 
				  (self[1][3] * self[2][1] - self[1][1] * self[2][3]) / det}
	local row3 = {(self[2][1] * self[3][2] - self[2][2] * self[3][1]) / det, 
				  (self[1][2] * self[3][1] - self[1][1] * self[3][2]) / det, 
				  (self[1][1] * self[2][2] - self[1][2] * self[2][1]) / det}
	return Matrix3(row1, row2, row3)
end

function clone(self)
	local matrix = super.clone(self)
	for row = 1,3 do
		local r = {}
		for col = 1,3 do
			r[col] = self[row][col]
		end
		matrix[row] = r
	end
	return matrix
end

function toString(self)
	local s = ''
	for i = 1, 3 do
		local str = ''
		for j = 1, 3 do
			str = str .. string.format(' [%d][%d] = %f', i, j, self[i][j])
		end
		str = str .. '\n'
		s = s .. str
	end
	return s
end