local inspect = require 'lib.inspect'
local Vector = require 'lib.vector'

require 'lib.inspect-print' (inspect)

lg = love.graphics
palette = require('lib.palease').load(love.filesystem.read('img/pal1.ase'))

-- TODO

local Player = require 'player'
local Bird = require 'bird'
local Boat = require 'boat'
local Debris = require 'debris'

local scale = 4

love.graphics.setDefaultFilter("nearest")

waterLevel = 430
local player = Player(Vector(300, 348))

local bird = Bird(Vector(500, 100), Vector(10, 0))
local bird2 = Bird(Vector(500, 120), Vector(-5, 1))

local boat = Boat(Vector(280, 388))

local d1 = Debris()

function love.load()
end

function love.update(dt)
  player:update(dt)

  for _, o in pairs {player, player.tool, bird, bird2, boat, d1} do
    if o.position and o.velocity then
      o.position = o.position + o.velocity * dt
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
  lg.circle("fill", 200, 80, 70)
  lg.setLineWidth(scale)
  lg.line(0, 280, lg.getWidth(), 280)

  lg.setColor(1, 1, 1)

  for _, o in pairs {player, bird, bird2, boat, d1} do
    if o.animation and o.position then
      o.animation:draw(o.position)
    end
  end

  player:draw()
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

