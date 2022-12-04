local machine = require('lib.statemachine')
local Vector = require 'lib.vector'

local Hook = require("lib.classic"):extend()

-- init speed [m/s]
local v0 = 20

-- m/s^2
local g = 9.81

local cos = math.cos(math.rad(45))
local sin = math.sin(math.rad(45))

-- TODO should hook know about player?
function Hook:new(position)
  -- tip of the hook position
  -- -- TODO when player moves
  self.position = position

  -- velocity of the tip of the hook
  self.velocity = Vector(0, 0)

  self:pickup()

  self.fsm = machine.create({
    initial = 'none',
    events = {
      {name = 'mousepressed', from = 'none', to = 'charging'},
      {name = 'mousereleased', from = 'charging', to = 'throwing'},

      -- mousedown when throwing? or must wait to land?
      {name = 'land', from = 'throwing', to = 'landed'},
      {name = 'mousepressed', from = 'landed', to = 'pulling'},
      {name = 'mousereleased', from = 'pulling', to = 'landed'},
      {name = 'pickup', from = {'landed', 'pulling'}, to = 'none'}
    }
  })

  self.fsm.onstatechange = function(_selffsm, _event, _from, to)
    --print(to, self.times)
  end

  self.fsm.onpickup = self.pickup
end

local withDefaultValue = function(t, default)
  return setmetatable(t, {
    __index = function(table, key)
      return default
    end
  })
end

function Hook:pickup()
  self.times = withDefaultValue({}, 0)
end

function Hook:getState()
  return self.fsm.current
end

function Hook:updateVelocity()
    self.velocity.x=0
    self.velocity.y=0

  if self.fsm:is('pulling') then
    self.velocity.x = -80

    -- TODO both directions
  elseif self.fsm:is('throwing') then
    self.velocity.x = v0 * cos * 6
    self.velocity.y = - (v0 * sin - g * self.times.throwing) * 6
  end
end

function Hook:update(dt)
  self.times[self.fsm.current] = self.times[self.fsm.current] + dt

  if self.position.y > waterLevel then
    self.fsm:land()
  end

  if self.fsm:is('landed') or self.fsm:is('pulling') then
    if self.times.throwing < 0.2 then
      self.fsm:pickup()
    end
  end

  self:updateVelocity()
end

function Hook:draw(position)
  lg.setLineWidth(4)
  lg.setColor(palette[4])
  if self.fsm:is('charging') then
    lg.line(position.x - 20, position.y - 70, position.x - 20 + self.times.charging * 10, position.y - 70)
  end

  lg.setColor(palette[9])

  lg.line(position.x, position.y, self.position.x, self.position.y)
end

function Hook:mousepressed()
  self.fsm:mousepressed()
end

function Hook:mousereleased()
  self.fsm:mousereleased()
end

return Hook
