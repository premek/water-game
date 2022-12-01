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

local d1 = Debris()

function love.load()
end

function love.update(dt)
  player:update(dt)

  for _, o in pairs {player, bird, bird2, boat, d1} do
    if o.position and o.velocity then
      o.position.x = o.position.x + o.velocity.x * dt
      o.position.y = o.position.y + o.velocity.y * dt
    end

    if o.animation then
      o.animation:update(dt)
    end

    if o.floating then
      o.position.y = o.position.y - dt * 40
      if o.position.y < 180 then
        o.position.y = -100

        -- FIXME remove
      end
    end
  end
end

function love.draw()
  lg.setColor(palette[11])
  lg.rectangle("fill", 0, 0, lg.getWidth(), lg.getHeight())

  lg.setColor(palette[9])
  lg.circle("fill", 200, 100, 90)
  lg.setLineWidth(scale)
  lg.line(0, 270, lg.getWidth(), 270)

  lg.setColor(1, 1, 1)

  for _, o in pairs {player, bird, bird2, boat, d1} do
    if o.animation and o.position then
      o.animation:draw(o.position)
    end
  end
end

function love.keypressed(k)
  if k == 'escape' then
    love.event.quit()
  end
end

function love.mousepressed(_x, _y, _button, _istouch, _presses)
  player:mousepressed()
end

function love.mousereleased(_x, _y, _button, _istouch, _presses)
  player:mousereleased()
end

