local Class = require('Class')
local GameObject = require('GameObject')
local CTTFont = require('runtime.TTFont.c')

local modName = ...

local UIFont = Class(modName, GameObject, false)

_G[modName] = UIfont
package.loaded[modName] = UIFont

local _ENV = UIFont

function new(class)
	return CTTFont.new(class)
end

function init(self, fontPath, fontSize)
	super.init(self)
	CTTFont.init(self, fontPath, fontSize)
	self.fontPath = fontPath
	self.fontSize = fontSize
end