local inspect = require 'lib.inspect'

require 'lib.inspect-print' (inspect)

local palette = require('lib.palease').load(love.filesystem.read('img/pal1.ase'))
local Player = require 'player'
local Bird = require 'bird'
local Boat = require 'boat'
local Debris = require 'debris'

local lg = love.graphics

local scale = 4

love.graphics.setDefaultFilter("nearest")

local player = Player({x = 300, y = 200})

local bird = Bird({x = 500, y = 100}, {x = 10, y = 0})
local bird2 = Bird({x = 500, y = 100}, {x = -5, y = 1})

local boat = Boat({x = 280, y = 241})

local d1 = Debris({x = 480, y = 241})

function love.load()
end

function love.update(dt)
  player:update(dt)
  bird:update(dt)
  bird2:update(dt)
  boat:update(dt)
  d1:update(dt)
end

function love.draw()
  lg.setColor(palette[11])
  lg.rectangle("fill", 0, 0, lg.getWidth(), lg.getHeight())

  lg.setColor(palette[9])
  lg.circle("fill", 200, 100, 90)
  lg.setLineWidth(scale)
  lg.line(0, 270, lg.getWidth(), 270)

  lg.setColor(1, 1, 1)

  player:draw()
  bird:draw()
  bird2:draw()
  boat:draw()
  d1:draw()
end

function love.keypressed(k)
  if k == 'escape' then
    love.event.quit()
  end
end
