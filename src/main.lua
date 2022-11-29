local json = require 'lib.json'
local inspect = require 'lib.inspect'
local paleAse = require 'lib.palease'

require 'lib.inspect-print' (inspect)

local palette = paleAse.load(love.filesystem.read('img/pal1.ase'))

-- table of named images, each has a texture, quads and optionally tagged (named) sets of quads
local images = {}

local lg = love.graphics

local scale = 4

local newImage = function(name)
  local image = {}
  image.allQuads = {}
  image.taggedQuads = {}
  image.texture = love.graphics.newImage("img/" .. name .. ".png")
  image.texture:setFilter("nearest")

  -- Aseprite > File > Export Sprite Sheet
  -- JSON Data checked, *Array* selected, Frame Tags checked
  local data = json.decode(love.filesystem.read("img/" .. name .. ".json"))

  -- all frames / quads
  for _, frame in ipairs(data.frames) do
    table.insert(image.allQuads, love.graphics.newQuad(
      frame.frame.x,
      frame.frame.y,
      frame.frame.w,
      frame.frame.h,
      data.meta.size.w,
      data.meta.size.h
    ))
  end

  -- tagged frames / quads if present
  for _, tag in ipairs(data.meta.frameTags) do
    image.taggedQuads[tag.name] = {}
    for i = tag.from + 1, tag.to + 1 do
      table.insert(image.taggedQuads[tag.name], image.allQuads[i])
    end
  end
  return image
end

local newAnimation = function(name, tag)
  return {
    image = images[name],
    tag = tag,
    currentTime = 0,

    -- todo read from json, depends on tag?
    duration = 0.7,

    getQuad = function(self)
      local quads = self.image.taggedQuads[self.tag]
      if not quads then
        quads = self.image.allQuads
      end
      local spriteNum = math.floor(self.currentTime / self.duration * #quads) + 1
      return quads[spriteNum]
    end,

    draw = function(self, position)
      love.graphics.draw(self.image.texture, self:getQuad(), position.x, position.y, 0, scale)
    end,

    update = function(self, dt)
      self.currentTime = (self.currentTime + dt) % self.duration
    end
  }
end

local newPlayer = function(animation, position)
  return {
    animation = animation,
    position = position,
    velocity = {x = 0, y = 0},
    health = 100,
    inventory = {},

    -- does this have to be like this?
    -- would ECS or some class system be better?
    draw = function(self)
      self.animation:draw(self.position)
    end,

    update = function(self, dt)
      self.velocity.x = math.max(0, self.velocity.x - dt * 10)
      self.velocity.y = math.max(0, self.velocity.y - dt * 10)

      if love.keyboard.isDown("right") then
        self.velocity.x = math.min(2, self.velocity.x + dt * 15)
      end

      if self.velocity.x > 0 then
        self.animation.tag = 'walk'
      else
        self.animation.tag = 'idle'
      end

      self.position.x = self.position.x + self.velocity.x
      self.position.y = self.position.y + self.velocity.y

      self.animation:update(dt)
    end,
  }
end

local newBird = function(animation, position, speed)
  return {
    animation = animation,
    position = position,
    speed = speed or 2,

    draw = function(self)
      self.animation:draw(self.position)
    end,

    update = function(self, dt)
      self.position.x = self.position.x + dt * self.speed
      self.animation:update(dt * self.speed * 0.1)
    end,
  }
end

function love.load()
  love.graphics.setDefaultFilter("nearest")

  for _, file in ipairs(love.filesystem.getDirectoryItems("img")) do
    if file:sub(-5) == ".json" then
      local name = file:sub(1, -6)
      images[name] = newImage(name)
    end
  end

  -- todo no globals
  player = newPlayer(newAnimation('char', 'idle'), {x = 300, y = 200})

  bird = newBird(newAnimation('bird'), {x = 500, y = 100})
  bird2 = newBird(newAnimation('bird'), {x = 500, y = 100}, 10)
end

function love.update(dt)
  player:update(dt)
  bird:update(dt)
  bird2:update(dt)
end

function love.draw()
  lg.setColor(palette[11])
  lg.rectangle("fill", 0, 0, lg.getWidth(), lg.getHeight())

  lg.setColor(palette[9])
  lg.circle("fill", 200, 100, 90)

  lg.setColor(palette[9])
  lg.setLineWidth(scale)
  lg.line(0, 270, lg.getWidth(), 270)

  lg.setColor(1, 1, 1)

  player:draw()
  bird:draw()
  bird2:draw()
end

function love.keypressed(_key)
end

