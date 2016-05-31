local Class = require('Class')
local UIBehaviour = require('UIBehaviour')

local modName = ...

local UILabelBehaviour = Class(modName, UIBehaviour, false)

_G[modName] = UILabelBehaviour
package.loaded[modName] = UILabelBehaviour

local _ENV = UILabelBehaviour

function init(self)
	super.init(self)
end