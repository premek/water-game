local Animation = require 'animation'

local Bird = require("lib.classic"):extend()

function Bird:new(position, velocity)
  self.animation = Animation('bird')
  self.position = position
  self.velocity = velocity
end

function Bird:draw()
  self.animation:draw(self.position)
end

function Bird:update(dt)
  self.position.x = self.position.x + self.velocity.x * dt
  self.position.y = self.position.y + self.velocity.y * dt

  self.animation:update(dt)
end

return Bird

