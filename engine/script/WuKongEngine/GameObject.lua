local Class = require('Class')
local Object = require('Object')

local modName = ...

local GameObject = Class(modName, Object, false)

_G[modName] = GameObject
package.loaded[modName] = GameObject

local string = string

local _ENV = GameObject

function init(self)
	self = super.init(self)
end

function static.destroy(class, object)
	-- body
end