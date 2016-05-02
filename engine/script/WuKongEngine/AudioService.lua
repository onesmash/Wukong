local Service = require('Service')
local Runtime = require('runtime')
local audio = require('runtime.audio')
local modName = ...

local AudioService = Class(modName, Service)

_G[modName] = AudioService
package.loaded[modName] = AudioService

local print = print

local type =  type

local table = table

local _ENV = AudioService

function init(self)
	super.init(self)
end

function start(self)
	audio.start()
	print('AudioService start')
end

function play(self, audioSource, limit)
	audio.play(audioSource, limit)
end

function playDelayed(self, audioSource, delaySeconds, limit)
	audio.playDelayed(audioSource, delaySeconds, limit)
end

function stop(self, audioSource)
	audio.stop(audioSource)
end