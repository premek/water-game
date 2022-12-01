local Animation = require 'animation'

local Boat = require("lib.classic"):extend()

function Boat:new(position)
  self.animation = Animation('items')
  self.animation.tag = 'woodblock'
  self.position = position
end

return Boat

