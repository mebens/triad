WeakWall = class("WeakWall", PhysicalEntity)
WeakWall.static.chunkWidth = 3
WeakWall.static.chunkHeight = 3

function WeakWall.static:fromXML(e)
  return WeakWall:new(tonumber(e.attr.x), tonumber(e.attr.y), tonumber(e.attr.width), tonumber(e.attr.height))
end

function WeakWall.static:generateQuads()
  WeakWall.chunkQuads = {}
  local cw, ch = 3, 3
  local iw = assets.images.weakWall:getWidth()
  local ih = assets.images.weakWall:getHeight()
  
  for i = 1, 12 do
    WeakWall.chunkQuads[i] = love.graphics.newQuad(
      math.random(0, iw - WeakWall.chunkWidth - 1),
      math.random(0, ih - WeakWall.chunkHeight - 1),
      WeakWall.chunkWidth, WeakWall.chunkHeight, iw, ih
    )
  end
end

function WeakWall:initialize(x, y, width, height)
  PhysicalEntity.initialize(self, x + width / 2, y + height / 2, "static")
  self.layer = 2
  self.width = width
  self.height = height
  self.map = Tilemap:new(assets.images.weakWall, TILE_SIZE, TILE_SIZE, width, height)
  if not WeakWall.chunkQuads then WeakWall:generateQuads() end
  
  local tw = math.ceil(self.width / TILE_SIZE)
  local th = math.ceil(self.height / TILE_SIZE)
  
  -- four corners
  self.map:set(0, 0, 1)
  self.map:set(tw - 1, 0, 3)
  self.map:set(tw - 1, th - 1, 9)
  self.map:set(0, th - 1, 7)
  
  -- horizontal edges
  if tw > 2 then
    self.map:setRect(1, 0, tw - 2, 1, 2)
    self.map:setRect(1, th - 1, tw - 2, 1, 8)
  end
  
  -- vertical edges
  if th > 2 then
    self.map:setRect(0, 1, 1, th - 2, 4)
    self.map:setRect(tw - 1, 1, 1, th - 2, 6)
  end
  
  -- middle filler
  if tw > 2 and th > 2 then self.map:setRect(1, 1, tw - 2, th - 2, 5) end
end

function WeakWall:added()
  self:setupBody()
  self.fixture = self:addShape(love.physics.newRectangleShape(self.width, self.height))
end

function WeakWall:draw()
  self.map:draw(self.x - self.width / 2, self.y - self.height / 2)
end

function WeakWall:die(direction)
  local count = math.min((self.width * self.height) / (WeakWall.chunkWidth * WeakWall.chunkHeight * 4), 50)
  
  for i = 1, count do
    self.world:add(Chunk:new(
      assets.images.weakWall,
      WeakWall.chunkQuads[math.random(1, #WeakWall.chunkQuads)],
      self.x - self.width / 2 + self.width * math.random(),
      self.y - self.height / 2 + self.height * math.random(),
      direction and (direction - math.tau / 4 + math.tau / 4 * math.random()) or math.tau * math.random()
    ))
  end
  
  self.world = nil
end
