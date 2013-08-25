Chunk = class("Chunk", PhysicalEntity)

function Chunk:initialize(img, quad, x, y, angle, color, minForce, maxForce)
  PhysicalEntity.initialize(self, x, y, "dynamic")
  self.layer = 7
  self.angle = angle
  self.image = img
  self.quad = quad
  self.minForce = minForce or 2
  self.maxForce = maxForce or 3
  self.color = color or { 255, 255, 255 }
  self.color[4] = 255
  
  if quad then
    local x, y, w, h = quad:getViewport()
    self.width = w
    self.height = h
  else
    self.width = img:getWidth()
    self.height = img:getHeight()
  end
end

function Chunk:added()
  self:setupBody()
  self.fixture = self:addShape(love.physics.newRectangleShape(self.width, self.height))
  self.fixture:setRestitution(0.75)
  self.fixture:setMask(2)
  self.fixture:setCategory(12)
  self:setLinearDamping(2)
  tween(self.color, "1:0.5", { [4] = 0 }, nil, self.die, self)
  
  local force = math.random(self.minForce, self.maxForce)
  self:applyLinearImpulse(math.cos(self.angle) * force, math.sin(self.angle) * force)
end

function Chunk:draw()
  if self.quad then
    love.graphics.setColor(self.color)
    love.graphics.drawq(self.image, self.quad, self.x, self.y, self.angle, 1, 1, self.width / 2, self.height / 2)
  else
    self:drawImage()
  end
end

function Chunk:die()
  self.world = nil
end
