local Animation = require("lib.classic"):extend()

local spritesheets = require('bedsheets').load('img')
local scale = 4

function Animation:new(name, tag)
  self.spritesheet = spritesheets[name]
  self.tag = tag
  self.currentTime = 0

  -- todo read from json, depends on tag?
  self.duration = 0.7
end

function Animation:getQuad()
  local quads = self.spritesheet:getQuads(self.tag)
  local spriteNum = math.floor(self.currentTime / self.duration * #quads) + 1
  return quads[spriteNum]
end

function Animation:draw(position)
  love.graphics.draw(self.spritesheet.image, self:getQuad(), position.x, position.y, 0, scale)
end

function Animation:update(dt)
  self.currentTime = (self.currentTime + dt) % self.duration
end

return Animation
