local Animation = require 'animation'
local machine = require('lib.statemachine')

local Player = require("lib.classic"):extend()

function Player:new(position)
  self.animation = Animation('char', 'idle')
  self.position = position
  self.velocity = {x = 0, y = 0}
  self.health = 100
  self.inventory = {}

  --self.tool = Hook()
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
    -- TODO debug log
    print(to, self.toolcharge, self.tooldistance)
  end

  self.fsm.onpickup = function(_selffsm, _event, _from, _to)
    self.tooldistance = 0
    self.toolcharge = 0
  end

  self.toolcharge = 0
  self.tooldistance = 0
end

function Player:update(dt)
  -- TODO where to use dt
  self.velocity.x = self.velocity.x * dt * 0.9
  self.velocity.y = self.velocity.y * dt * 0.9

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

  if self.fsm:is('charging') then
    self.toolcharge = self.toolcharge + dt
  elseif self.fsm:is('throwing') then
    self.toolcharge = self.toolcharge - dt
    self.tooldistance = self.tooldistance + dt
    if self.toolcharge < 0 then
      self.fsm:land()
    end
  elseif self.fsm:is('landed') then
    -- pickup immediately if not thrown far enough
    if self.tooldistance < 0.2 then
      self.fsm:pickup()
    end
  elseif self.fsm:is('pulling') then
    self.tooldistance = self.tooldistance - dt
    if self.tooldistance < 0.2 then
      self.fsm:pickup()
    end
  end

  --  self.tool:update(dt)

  --print(self.fsm.current)
end

function Player:mousepressed()
  self.fsm:mousepressed()
end
function Player:mousereleased()
  self.fsm:mousereleased()
end

return Player
