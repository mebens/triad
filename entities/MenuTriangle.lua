MenuTriangle = class("MenuTriangle", Entity)

function MenuTriangle:initialize(speed, minScale, maxScale, tone)
  Entity.initialize(self, love.graphics.width / 2, love.graphics.height / 2)
  self.layer = 2
  self.angle = 0
  self.angleSpeed = speed or math.tau / 8
  self.minScale = minScale or 0.8
  self.minScale = maxScale or 1.2
  self.scale = self.minScale
  self.scaleTime = 10
  self.radius = 150
  tone = tone or 110
  self.color = { tone, tone, tone }
end

function MenuTriangle:added()
  self:scaleUp()
end

function MenuTriangle:update(dt)
  self.angle = (self.angle + self.angleSpeed * dt) % math.tau
end

function MenuTriangle:draw()
  local points = {}
  
  for i = 0, 2 do
    points[#points + 1] = self.x + self.radius * self.scale * math.cos(math.tau * (i / 3) + self.angle)
    points[#points + 1] = self.y + self.radius * self.scale * math.sin(math.tau * (i / 3) + self.angle)
  end
  
  love.graphics.setColor(self.color)
  love.graphics.setLineWidth(5)
  love.graphics.triangle("line", unpack(points))
  love.graphics.setLineWidth(1)
end

function MenuTriangle:scaleUp()
  self:animate(self.scaleTime / 2, { scale = self.maxScale }, self.quadOut, self.scaleDown, self)
end

function MenuTriangle:scaleDown()
  self:animate(self.scaleTime / 2, { scale = self.minScale }, self.quadIn, self.scaleUp, self)
end
