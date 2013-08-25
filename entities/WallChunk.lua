WallChunk = class("WallChunk", PhysicalEntity)
WallChunk.static.width = 3
WallChunk.static.height = 3

function WallChunk.static:generateQuads()
  WallChunk.quads = {}
  local iw = assets.images.weakWall:getWidth()
  local ih = assets.images.weakWall:getHeight()
  
  for i = 1, 12 do
    WallChunk.quads[i] = love.graphics.newQuad(
      math.random(0, iw - WallChunk.width - 1),
      math.random(0, ih - WallChunk.height - 1),
      WallChunk.width,
      WallChunk.height,
      iw,
      ih
    )
  end
end

function WallChunk:initialize(x, y, angle)
  PhysicalEntity.initialize(self, x, y, "dynamic")
  self.layer = 6
  self.angle = angle
  self.width = WallChunk.width
  self.height = WallChunk.height
  self.image = assets.images.weakWall
  self.minForce = 2
  self.maxForce = 3
  self.color = { 255, 255, 255, 255 }
  if not WallChunk.quads then WallChunk:generateQuads() end
  self.quad = WallChunk.quads[math.random(1, #WallChunk.quads)]
end

function WallChunk:added()
  self:setupBody()
  self.fixture = self:addShape(love.physics.newRectangleShape(self.width, self.height))
  self.fixture:setRestitution(0.75)
  self.fixture:setMask(2)
  self.fixture:setCategory(12)
  self:setLinearDamping(2)
  tween(self.color, "0.5:1", { [4] = 0 }, nil, self.die, self)
  
  local force = math.random(self.minForce, self.maxForce)
  self:applyLinearImpulse(math.cos(self.angle) * force, math.sin(self.angle) * force)
end

function WallChunk:draw()
  love.graphics.setColor(self.color)
  love.graphics.drawq(self.image, self.quad, self.x, self.y, self.angle, 1, 1, self.width / 2, self.height / 2)
end

function WallChunk:die()
  self.world = nil
end
