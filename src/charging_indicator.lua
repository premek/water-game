local Vector = require 'lib.vector'

local ChargingIndicator = require("lib.classic"):extend()

local startAngle = math.pi * 0.5
local fullAngle = math.pi * 2

--static
function ChargingIndicator.draw(charge, position)
  if not charge then
    return
  end

  lg.setLineWidth(4)
  lg.setColor(palette[4])

  lg.arc("line", "open", position.x, position.y, 15, startAngle, startAngle + fullAngle * charge, 15)
end

return ChargingIndicator
