local Class = require('Class')
local Object = require('Object')
local Vector3 = require('Vector3')
local AABB = require('AABB')
local DynamicTree = require('DynamicTree')

local modName = ...

local BroadPhase = Class(modName, Object, false)

_G[modName] = BroadPhase
package.loaded[modName] = BroadPhase

local math = math
local ipairs = ipairs
local table = table
local print = print
local _ENV = BroadPhase

nullProxy = -1

function pairLessThan(a, b)
	if a.proxyIdA < b.proxyIdA then
		return true
	end

	if a.proxyIdA == b.proxyIdA then
		return a.proxyIdB < b.proxyIdB
	end

	return false
end

function init(self)
	super.init(self)
	self._proxyCount = 0
	self._tree = DynamicTree()

	self._moveCount = 0
	self._moveBuffer = {}

	self._pairCount = 0
	self._pairBuffer = {}

	self._queryProxyId = BroadPhase.nullProxy
end

function createProxy(self, aabb, data)
	local proxyId = self._tree:createProxy(aabb, data)
	self._proxyCount = self._proxyCount + 1
	self:bufferMove(proxyId)
	return proxyId
end

function destroyProxy(self, proxyId)
	self:unBufferMove(proxyId)
	self._proxyCount = self._proxyCount - 1
	self._tree:destroyProxy(proxyId)
end

function moveProxy(self, proxyId, aabb, displacement)
	local moved = self._tree:moveProxy(proxyId, aabb, displacement)
	if moved then
		self:bufferMove(proxyId)
	end
end

function bufferMove(self, proxyId)
	self._moveCount = self._moveCount + 1
	self._moveBuffer[self._moveCount] = proxyId
end

function unBufferMove(self, proxyId)
	for i = 1, self._moveCount do
		if self._moveBuffer[i] == proxyId then
			self._moveBuffer[i] = BroadPhase.nullProxy
		end
	end
end

function queryCallback(self, proxyId)
	if proxyId == self._queryProxyId then
		return true
	end

	local pair = {}
	pair.proxyIdA = math.min(proxyId, self._queryProxyId)
	pair.proxyIdB = math.max(proxyId, self._queryProxyId)
	self._pairCount = self._pairCount + 1
	self._pairBuffer[self._pairCount] = pair

	return true
end

function testOverlap(self, proxyIdA, proxyIdB)
	local aabbA = self._tree:getFatAABB(proxyIdA)
	local aabbB = self._tree:getFatAABB(proxyIdB)
	return AABB.testOverlap(aabbA, aabbB)
end

function updatePairs(self, delegate)
	self._pairCount = 0
	self._pairBuffer = {}

	for _, proxyId in ipairs(self._moveBuffer) do
		if proxyId ~= BroadPhase.nullProxy then
			self._queryProxyId = proxyId
			local fatAABB = self._tree:getFatAABB(self._queryProxyId)
			self._tree:query(self, fatAABB)
		end
	end

	self._moveCount = 0
	self._moveBuffer = {}

	table.sort(self._pairBuffer, BroadPhase.pairLessThan)

	local i = 1
	while i <= self._pairCount do
		local pair = self._pairBuffer[i]
		local dataA = self._tree:getData(pair.proxyIdA)
		local dataB = self._tree:getData(pair.proxyIdB)

		delegate:addPair(dataA, dataB)
		i = i + 1

		while i <= self._pairCount do
			local nextPair = self._pairBuffer[i]
			if nextPair.proxyIdA ~= pair.proxyIdA or nextPair.proxyIdB ~= pair.proxyIdB then
				break
			end
			i = i + 1
		end
	end

end

function query(self, delegate, aabb)
	self._tree:query(delegate, aabb)
end

function getData(self, proxyId)
	return self._tree:getData(proxyId)
end

function getFatAABB(self, proxyId)
	return self._tree:getFatAABB(proxyId)
end
