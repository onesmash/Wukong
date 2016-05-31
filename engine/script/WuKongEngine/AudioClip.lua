local Class = require('Class')
local GameObject = require('GameObject')
local CAudioClip = require('runtime.AudioClip.c')

local modName = ...

local AudioClip = Class(modName, GameObject, false)

_G[modName] = AudioClip
package.loaded[modName] = AudioClip

local _ENV = AudioClip

function new(class)
	return CAudioClip.new(class)
end

function init(self, filePath)
	super.init(self)
	CAudioClip.init(self, filePath)
end