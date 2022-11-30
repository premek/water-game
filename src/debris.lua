local Animation = require 'animation'

local Debris = require("lib.classic"):extend()

function Debris:new(position)
  self.animation = Animation('items')
  self.animation.tag = 'plastic'
  self.position = position
  self.velocity = {x = -20, y = 0}
end

function Debris:draw()
  self.animation:draw(self.position)
end

function Debris:update(dt)
  self.position.x = self.position.x + self.velocity.x * dt
  self.position.y = self.position.y + self.velocity.y * dt

  self.animation:update(dt)
end

return Debris

