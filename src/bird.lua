local Animation = require 'animation'

local Bird = require("lib.classic"):extend()

function Bird:new(position, velocity)
  self.animation = Animation('bird')
  self.position = position
  self.velocity = velocity
end

return Bird

