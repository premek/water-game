local Animation = require 'animation'

local Boat = require("lib.classic"):extend()

function Boat:new(position)
  self.animation = Animation('items')
  self.animation.tag = 'woodblock'
  self.position = position
end

function Boat:draw()
  self.animation:draw(self.position)
end

function Boat:update(dt)
  self.animation:update(dt)
end

return Boat

