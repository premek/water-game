local Animation = require 'animation'
local Vector = require 'lib.vector'

local Debris = require("lib.classic"):extend()

function Debris:new()
  self.animation = Animation('items')
  self.animation.tag = 'plastic'
  self.position = Vector(500, 500)
  self.floating = true
end

return Debris

