local Class = require('Class')
local Component = require('Component')
local CAudioSource = require('runtime.AudioSource.c')
local AudioService = require('AudioService')
local Runtime = require('runtime')

local modName = ...

local AudioSource = Class(modName, Component, false)

local print = print

_G[modName] = AudioSource
package.loaded[modName] = AudioSource

local _ENV = AudioSource

function new(class)
	return CAudioSource.new(class)
end

function init(self)
	super.init(self)
end

function setClip(self, clip)
	CAudioSource.setClip(self, clip)
end

function play(self, limit)
	local audioService = Runtime.getService(AudioService)
	audioService:play(self, limit or -1)
end