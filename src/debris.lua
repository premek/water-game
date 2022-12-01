local Animation = require 'animation'

local Debris = require("lib.classic"):extend()

function Debris:new()
  self.animation = Animation('items')
  self.animation.tag = 'plastic'
  self.position = {x = 500, y = 500}
  self.floating = true
end

return Debris

