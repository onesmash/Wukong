--[[
inspired by Box2D
]]---


local Class = require('Class')
local Object = require('Object')
local AABB = require('AABB')
local TreeNode = require('TreeNode')
local Vector3 = require('Vector3')
local Stack = require('Stack')

local modName = ...

local DynamicTree = Class(modName, Object, false)

_G[modName] = DynamicTree
package.loaded[modName] = DynamicTree

local math = math
local print = print
local debug = debug

local _ENV = DynamicTree

function init(self)
	super.init(self)
	self._root = TreeNode.null
	self._nodeCount = 0
	self._nodeCapacity = 16
	self._nodes = {}
	for i = 1, self._nodeCapacity - 1 do
		local node = TreeNode()
		node.parent = TreeNode.null
		node.next = i + 1
		node.height = -1
		self._nodes[i] = node
	end

	self._nodes[self._nodeCapacity] = TreeNode()
	self._nodes[self._nodeCapacity].parent = TreeNode.null
	self._nodes[self._nodeCapacity].next = TreeNode.null
	self._nodes[self._nodeCapacity].height = -1
	self._freeList = 1

	self._insertionCount = 0

end

function createProxy(self, aabb, data)
	local proxyId = self:allocateNode()
	-- Fatten the aabb.
	local extension = Vector3(AABB.extension, AABB.extension, 0)
	local node = self._nodes[proxyId]
	node.aabb.lowerBound = aabb.lowerBound - extension
	node.aabb.upperBound = aabb.upperBound + extension
	node.data = data
	node.height = 0

	self:insertLeaf(proxyId)
	return proxyId
end

function destroyProxy(self, proxyId)
	self:removeLeaf(proxyId)
	self:freeNode(proxyId)
end

function moveProxy(self, proxyId, aabb, displacement)
	if self._nodes[proxyId].aabb:contains(aabb) then
		return false
	end

	self:removeLeaf(proxyId)

	local extension = Vector3(AABB.extension, AABB.extension, 0)
	local b = AABB(aabb.lowerBound - extension, aabb.upperBound + extension)

	-- Predict AABB displacement
	local d = displacement:clone()
	d:mul(AABB.multiplier, AABB.multiplier, AABB.multiplier)

	if d.x < 0 then
		b.lowerBound.x = b.lowerBound.x + d.x
	else
		b.upperBound.x = b.upperBound.x + d.x
	end

	if d.y < 0 then
		b.lowerBound.y = b.lowerBound.y + d.y
	else
		b.upperBound.y = b.upperBound.y + d.y
	end

	self._nodes[proxyId].aabb = b

	self:insertLeaf(proxyId)
	return true
end

function allocateNode(self)
	if self._freeList == TreeNode.null then
		self._nodeCapacity = 2 * self._nodeCapacity
		for i = self._nodeCount + 1, self._nodeCapacity - 1 do
			self._nodes[i] = TreeNode()
			self._nodes[i].parent = TreeNode.null
			self._nodes[i].next = i + 1
			self._nodes[i].height = -1
		end
		self._nodes[self._nodeCapacity] = TreeNode()
		self._nodes[self._nodeCapacity].parent = TreeNode.null
		self._nodes[self._nodeCapacity].next = TreeNode.null
		self._nodes[self._nodeCapacity].height = -1
		self._freeList = self._nodeCount + 1
	end
	local nodeId = self._freeList
	self._freeList = self._nodes[nodeId].next
	local node = self._nodes[nodeId]
	node.next = TreeNode.null
	node.parent = TreeNode.null
	node.childL = TreeNode.null
	node.childR = TreeNode.null
	node.height = 0
	node.data = nil
	self._nodeCount = self._nodeCount + 1
	return nodeId
end

function freeNode(self, nodeId)
	local node = self._nodes[nodeId]
	node.parent = TreeNode.null
	node.next = self._freeList
	node.data = nil
	node.height = -1
	self._freeList = nodeId
	self._nodeCount = self._nodeCount - 1
end

function insertLeaf(self, leaf)
	self._insertionCount = self._insertionCount + 1

	if self._root == TreeNode.null then
		self._root = leaf
		self._nodes[self._root].parent = TreeNode.null
		return
	end

	-- Find the best sibling for this node
	local leafAABB = self._nodes[leaf].aabb
	local index = self._root	
	while not self._nodes[index]:isLeaf() do
		local node = self._nodes[index]
		local childL = node.childL
		local childR = node.childR

		local area = node.aabb:getPerimeter()

		local combinedAABB = AABB.combineAABBs(node.aabb, leafAABB)
		local combinedArea = combinedAABB:getPerimeter()

		-- Cost of creating a new parent for this node and the new leaf
		local cost = 2 * combinedArea

		-- Minimum cost of pushing the leaf further down the tree
		local inheritanceCost = 2 * (combinedArea - area)

		-- Cost of descending into childL
		local costL = 0
		if self._nodes[childL]:isLeaf() then
			local aabb = AABB.combineAABBs(leafAABB, self._nodes[childL].aabb)
			costL = aabb:getPerimeter() + inheritanceCost
		else
			local aabb = AABB.combineAABBs(leafAABB, self._nodes[childL].aabb)
			local oldArea = self._nodes[childL].aabb:getPerimeter()
			local newArea = aabb:getPerimeter()
			costL = newArea - oldArea + inheritanceCost
		end

		-- Cost of descending into childR
		local costR = 0
		if self._nodes[childR]:isLeaf() then
			local aabb = AABB.combineAABBs(leafAABB, self._nodes[childR].aabb)
			costR = aabb:getPerimeter() + inheritanceCost
		else
			local aabb = AABB.combineAABBs(leafAABB, self._nodes[childR].aabb)
			local oldArea = self._nodes[childR].aabb:getPerimeter()
			local newArea = aabb:getPerimeter()
			costR = newArea - oldArea + inheritanceCost
		end

		-- Descend according to the minimum cost.
		if cost < costL and cost < costR then
			break
		end

		if costL < costR then
			index = childL
		else
			index = childR
		end
	end

	local sibling = index

	-- Create a new parent.
	local oldParent = self._nodes[sibling].parent
	local newParent = self:allocateNode()
	local newParentNode = self._nodes[newParent]
	newParentNode.parent = oldParent
	newParentNode.data = nil
	newParentNode.aabb:combine2AABB(leafAABB, self._nodes[sibling].aabb)
	newParentNode.height = self._nodes[sibling].height + 1

	if oldParent ~= TreeNode.null then
		-- The sibling was not the root.
		if self._nodes[oldParent].childL == sibling then
			self._nodes[oldParent].childL = newParent
		else
			self._nodes[oldParent].childR = newParent
		end
		self._nodes[newParent].childL = sibling
		self._nodes[newParent].childR = leaf
		self._nodes[sibling].parent = newParent
		self._nodes[leaf].parent = newParent
	else
		-- The sibling was the root.
		self._nodes[newParent].childL = sibling
		self._nodes[newParent].childR = leaf
		self._nodes[sibling].parent = newParent
		self._nodes[leaf].parent = newParent
		self._root = newParent
	end

	-- Walk back up the tree fixing heights and AABBs
	index = self._nodes[leaf].parent
	while index ~= TreeNode.null do
		index = self:balance(index)
		local childL = self._nodes[index].childL
		local childR = self._nodes[index].childR

		self._nodes[index].height = 1 + math.max(self._nodes[childL].height, self._nodes[childR].height)
		self._nodes[index].aabb:combine2AABB(self._nodes[childL].aabb, self._nodes[childR].aabb)

		index = self._nodes[index].parent
	end
end

function removeLeaf(self, leaf)
	if leaf == self._root then
		self._root = TreeNode.null
		return
	end

	local parent = self._nodes[leaf].parent
	local grandParent = self._nodes[parent].parent
	local sibling = TreeNode.null
	if self._nodes[parent].childL == leaf then
		sibling = self._nodes[parent].childR
	else
		sibling = self._nodes[parent].childL
	end

	if grandParent ~= TreeNode.null then
		-- Destroy parent and connect sibling to grandParent.
		if self._nodes[grandParent].childL == parent then
			self._nodes[grandParent].childL = sibling
		else
			self._nodes[grandParent].childR = sibling
		end
		self._nodes[sibling].parent = grandParent
		self:freeNode(parent)

		-- Adjust ancestor bounds.
		local index = grandParent
		while index ~= TreeNode.null do
			index = self:balance(index)

			local childL = self._nodes[index].childL
			local childR = self._nodes[index].childR

			self._nodes[index].aabb:combine2AABB(self._nodes[childL].aabb, self._nodes[childR].aabb)
			self._nodes[index].height = 1 + math.max(self._nodes[childL].height, self._nodes[childR].height)

			index = self._nodes[index].parent
		end
	else
		self._root = sibling
		self._nodes[sibling].parent = TreeNode.null
		self:freeNode(parent)
	end
end

-- Perform a left or right rotation if node A is imbalanced.
-- Returns the new root index.
function balance(self, iA)
	local nodeA = self._nodes[iA]
	if nodeA:isLeaf() or nodeA.height < 2 then
		return iA
	end

	local iL = nodeA.childL
	local iR = nodeA.childR

	local nodeL = self._nodes[iL]
	local nodeR = self._nodes[iR]

	local balance = nodeR.height - nodeL.height

	-- Rotate nodeR up
	if balance > 1 then
		local iRL = nodeR.childL
		local iRR = nodeR.childR

		local nodeRL = self._nodes[iRL]
		local nodeRR = self._nodes[iRR]

		-- Swap nodeA and nodeR
		nodeR.childL = iA
		nodeR.parent = nodeA.parent
		nodeA.parent = iR

		-- nodeA's old parent should point to nodeR
		if nodeR.parent ~= TreeNode.null then
			if self._nodes[nodeR.parent].childL == iA then
				self._nodes[nodeR.parent].childL = iR
			else
				self._nodes[nodeR.parent].childR = iR
			end
		else
			self._root = iR
		end

		-- Rotate
		if nodeRL.height > nodeRR.height then
			nodeR.childR = iRL
			nodeA.childR = iRR
			nodeRR.parent = iA
			nodeA.aabb:combine2AABB(nodeL.aabb, nodeRR.aabb)
			nodeR.aabb:combine2AABB(nodeA.aabb, nodeRL.aabb)

			nodeA.height = 1 + math.max(nodeL.height, nodeRR.height)
			nodeR.height = 1 + math.max(nodeA.height, nodeRL.height)
		else
			nodeR.childR = iRR
			nodeA.childR = iRL
			nodeRL.parent = iA
			nodeA.aabb:combine2AABB(nodeL.aabb, nodeRL.aabb)
			nodeR.aabb:combine2AABB(nodeA.aabb, nodeRR.aabb)

			nodeA.height = 1 + math.max(nodeL.height, nodeRL.height)
			nodeR.height = 1 + math.max(nodeA.height, nodeRR.height)
		end
		return iR
	end

	-- Rotate nodeL up
	if balance < -1 then
		local iLL = nodeL.childL
		local iLR = nodeL.childR

		local nodeLL = self._nodes[iLL]
		local nodeLR = self._nodes[iLR]

		-- Swap nodeA and nodeR
		nodeL.childL = iA
		nodeL.parent = nodeA.parent
		nodeA.parent = iL

		-- nodeA's old parent should point to nodeL
		if nodeL.parent ~= TreeNode.null then
			if self._nodes[nodeL.parent].childL == iA then
				self._nodes[nodeL.parent].childL = iL
			else
				self._nodes[nodeL.parent].childR = iL
			end
		else
			self._root = iL
		end

		-- Rotate
		if nodeLL.height > nodeLR.height then
			nodeL.childR = iLL
			nodeA.childL = iLR
			nodeLR.parent = iA
			nodeA.aabb:combine2AABB(nodeR.aabb, nodeLR.aabb)
			nodeL.aabb:combine2AABB(nodeA.aabb, nodeLL.aabb)

			nodeA.height = 1 + math.max(nodeR.height, nodeLR.height)
			nodeL.height = 1 + math.max(nodeA.height, nodeLL.height)
		else
			nodeL.childR = iLR
			nodeA.childL = iLL
			nodeLL.parent = iA
			nodeA.aabb:combine2AABB(nodeR.aabb, nodeLL.aabb)
			nodeL.aabb:combine2AABB(nodeA.aabb, nodeLR.aabb)

			nodeA.height = 1 + math.max(nodeR.height, nodeLL.height)
			nodeL.height = 1 + math.max(nodeA.height, nodeLR.height)
		end
		return iL
	end

	return iA
end

function getFatAABB(self, proxyId)
	return self._nodes[proxyId].aabb
end

function getData(self, proxyId)
	return self._nodes[proxyId].data
end

function query(self, delegate, aabb)
	local stack = Stack()
	stack:push(self._root)

	while stack:size() > 0 do
		local nodeId = stack:pop()
		if nodeId ~= TreeNode.null then
			local node = self._nodes[nodeId]
			if AABB.testOverlap(node.aabb, aabb) then
				if node:isLeaf() then
					local proceed = delegate:queryCallback(nodeId)
					if not proceed then
						return
					end
				else
					stack:push(node.childL)
					stack:push(node.childR)
				end
			end
		end
	end

end

function rayCast(self, callback, ray)
	local origin = ray.origin
	local direction = ray.direction
end