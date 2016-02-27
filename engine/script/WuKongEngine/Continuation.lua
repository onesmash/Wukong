local Class = require('Class')
local Object = require('Object')

local modName = ...

local Continuation = Class(modName, Object)
local print = print

_G[modName] = Continuation
package.loaded[modName] = Continuation

local _ENV = Continuation

function init(self, c)
	super.init(self)
	self.c = c;
end