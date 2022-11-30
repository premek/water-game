local Animation = require 'animation'

local Player = require("lib.classic"):extend()

function Player:new(position)
  self.animation = Animation('char', 'idle')
  self.position = position
  self.velocity = {x = 0, y = 0}
  self.health = 100
  self.inventory = {}
end

function Player:draw()
  self.animation:draw(self.position)
end

function Player:update(dt)
  self.velocity.x = math.max(0, self.velocity.x - dt * 10)
  self.velocity.y = math.max(0, self.velocity.y - dt * 10)

  if love.keyboard.isDown("right") then
    self.velocity.x = math.min(2, self.velocity.x + dt * 15)
  end

  if self.velocity.x > 0 then
    self.animation.tag = 'walk'
  else
    self.animation.tag = 'idle'
  end

  self.position.x = self.position.x + self.velocity.x * dt
  self.position.y = self.position.y + self.velocity.y * dt

  self.animation:update(dt)
end

return Player
