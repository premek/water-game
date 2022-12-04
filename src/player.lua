local Animation = require 'animation'
local Hook = require 'hook'
local Vector = require 'lib.vector'

local Player = require("lib.classic"):extend()

local toolOffset = Vector(46, 54)

function Player:new(position)
  self.animation = Animation('char', 'idle')
  self.position = position
  self.velocity = Vector(0, 0)
  self.health = 100
  self.inventory = {}
  self.tool = Hook(position + toolOffset)
end

function Player:update(dt)
  -- TODO where to use dt
  self.velocity = self.velocity * dt * 0.98

  if love.keyboard.isDown("a") then
    self.velocity.x = self.velocity.x - dt * 150
  end
  if love.keyboard.isDown("d") then
    self.velocity.x = self.velocity.x + dt * 150
  end

  if self.velocity.x > 0 then
    self.animation.tag = 'walk'
    self.animation.mirrored = false
  elseif self.velocity.x < 0 then
    self.animation.tag = 'walk'
    self.animation.mirrored = true
  else
    self.animation.tag = 'idle'
  end

  self.tool:update(dt)
  local toolState = self.tool:getState()
  if toolState ~= 'none' then
    self.animation.tag = toolState
  end
end

function Player:draw()
  self.tool:draw(self.position + toolOffset)
end

function Player:mousepressed()
  self.tool:mousepressed()
end
function Player:mousereleased()
  self.tool:mousereleased()
end

return Player
