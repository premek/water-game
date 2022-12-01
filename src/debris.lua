local Animation = require 'animation'

local Debris = require("lib.classic"):extend()

function Debris:new(position)
  self.animation = Animation('items')
  self.animation.tag = 'plastic'
  self.position = position
  self.velocity = {x = -20, y = 0}
end

return Debris

