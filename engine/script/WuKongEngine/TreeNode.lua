local Class = require('Class')
local Object = require('Object')
local AABB = require('AABB')

local modName = ...

local TreeNode = Class(modName, Object, false)

_G[modName] = TreeNode
package.loaded[modName] = TreeNode

local _ENV = TreeNode

static.null = -1

function init(self)
	super.init(self)
	self.parent = TreeNode.null
	self.childL = TreeNode.null
	self.childR = TreeNode.null
	self.height = height or -1
	self.next = TreeNode.null
	self.aabb = AABB()
	self.data = nil
end

function isLeaf(self)
	return self.childL == TreeNode.null
end