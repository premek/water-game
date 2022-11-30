--[[

Loads Sprite Sheets from Aseprite to be used in LOVE.

Sprite Sheet should be exported from aseprite using: File > Export Sprite Sheet,
*JSON Data* checked, *Array* selected, *Frame Tags* checked

Frame tags are optional and could be used e.g. for separate 'walk', 'jump', 'idle' etc. animations.

This only loads the sprite sheet (quads), you have to animate them yourself (see example below).

All the JSON files from the provided directory will be loaded.
The PNG files must have the same name as the JSON files (except the extension).

Requires json module from https://github.com/rxi/json.lua
(or you could provide your own decoder function with the same api)

Usage:

This example expects files:
- img/player.png
- img/player.json
with tagged frames called "walking" in aseprite (this could be ommited)

```
local spritesheets = require('bedsheets').load('img')

local currentTime = 0
local duration = 3

function love.draw()
  local spritesheet = spritesheets["player"]
  local quads = spritesheet:getQuads("walking")
  local spriteNum = math.floor(currentTime / duration * #quads) + 1
  love.graphics.draw(spritesheet.image, quads[spriteNum], 100, 200)
end

function love:update(dt)
  currentTime = (currentTime + dt) % duration
end

```
]]

local loadData = function(directory, name, decoder)
  return decoder(love.filesystem.read(directory .. "/" .. name .. ".json"))
end

local loadImage = function(directory, name)
  local image = love.graphics.newImage(directory .. "/" .. name .. ".png")
  image:setFilter("nearest")
  return image
end

local getAllQuads = function(data)
  local quads = {}
  for _, frame in ipairs(data.frames) do
    table.insert(quads, love.graphics.newQuad(
      frame.frame.x,
      frame.frame.y,
      frame.frame.w,
      frame.frame.h,
      data.meta.size.w,
      data.meta.size.h
    ))
  end
  return quads
end

local getTaggedQuads = function(data, allQuads)
  local taggedQuads = {}
  for _, tag in ipairs(data.meta.frameTags) do
    taggedQuads[tag.name] = {}

    -- frames 0-based in aseprite, 1-based in love
    for i = tag.from + 1, tag.to + 1 do
      table.insert(taggedQuads[tag.name], allQuads[i])
    end
  end
  return taggedQuads
end

local newSpritesheet = function(directory, name, data)
  local allQuads = getAllQuads(data)

  return {
    image = loadImage(directory, name),
    allQuads = allQuads,
    taggedQuads = getTaggedQuads(data, allQuads),

    getQuads = function(self, tag)
      if self.taggedQuads[tag] ~= nil then
        return self.taggedQuads[tag]
      end
      return self.allQuads
    end
  }
end

return {
  load = function(directory, decoder)
    if decoder == nil then
      decoder = require('lib.json').decode
    end

    local spritesheets = {}

    for _, file in ipairs(love.filesystem.getDirectoryItems(directory)) do
      if file:sub(-5) == ".json" then
        -- filename without extension
        local name = file:sub(1, -6)
        local data = loadData(directory, name, decoder)
        spritesheets[name] = newSpritesheet(directory, name, data)
      end
    end

    return spritesheets
  end
}
