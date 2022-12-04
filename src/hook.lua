local machine = require('lib.statemachine')
local Vector = require 'lib.vector'
local ChargingIndicator = require 'charging_indicator'

local Hook = require("lib.classic"):extend()

-- init speed 
local v0 = 20
local g = 9.81
local magic = 10

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
      -- mousedown when throwing? or must wait to land?
      {name = 'mousepressed', from = 'none', to = 'charging'},
      {name = 'mousereleased', from = 'charging', to = 'throwing'},
      {name = 'land', from = 'throwing', to = 'landed'},
      {name = 'mousepressed', from = 'landed', to = 'pulling'},
      {name = 'mousereleased', from = 'pulling', to = 'landed'},
      {name = 'pickup', from = {'landed', 'pulling'}, to = 'none'}
    }
  })

  --self.fsm.onstatechange = function(_selffsm, _event, _from, to)
  --  print(to, self.times)
  --end

  self.fsm.onpickup = self.pickup
end

function Hook:pickup()
  self.times = {}
end

function Hook:getState()
  return self.fsm.current
end

function Hook:updateVelocity()
  self.velocity.x = 0
  self.velocity.y = 0

  if self.fsm:is('pulling') then
    self.velocity.x = -80

    -- TODO both directions
  elseif self.fsm:is('throwing') then
    local charge = self:getCharge()
    local angle = math.rad(45 * charge)
    self.velocity.x = v0 * charge * math.cos(angle) * magic
    self.velocity.y = - (v0 * charge * math.sin(angle) - g * self.times.throwing) * magic
  end
end

local maxCharge = 1.5
function Hook:getCharge()
  return math.min(maxCharge, self.times.charging) / maxCharge
end

function Hook:update(dt)
  self.times[self.fsm.current] = (self.times[self.fsm.current] or 0) + dt

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

local chargeIndicatorOffset = Vector(-20, -70)

function Hook:draw(position)
  if self.fsm.current == 'charging' then
    ChargingIndicator.draw(self:getCharge(), position + chargeIndicatorOffset)
  end

  if self.fsm.current ~= 'none' and self.fsm.current ~= 'charging' then
    lg.setLineWidth(2)

    -- line
    lg.setColor(palette[9])
    lg.line(position.x, position.y, self.position.x, self.position.y)

    -- hook end
    lg.setColor(palette[10])
    lg.circle("line", self.position.x + 2, self.position.y, 2.5, 6)
    lg.line(
      self.position.x + 3,
      self.position.y + 1,
      self.position.x+8,
      self.position.y + 6,
      self.position.x + 12,
      self.position.y + 5,
      self.position.x + 12,
      self.position.y + 1
    )
  end
end

function Hook:mousepressed()
  self.fsm:mousepressed()
end

function Hook:mousereleased()
  self.fsm:mousereleased()
end

return Hook
