Smoke = class("Smoke", PhysicalEntity)

function Smoke:initialize(x, y)
  PhysicalEntity.initialize(self, x, y, "static")
  self.layer = 0
  self.width = 40
  self.height = 40
  self.time = 4
  self.timer = self.time
  self.speedTime = self.time / 4
  self.speedTimer = self.speedTime
  
  local ps = love.graphics.newParticleSystem(assets.images.smoke, 200)
  ps:setColors(255, 255, 255, 180, 255, 255, 255, 120, 255, 255, 255, 0)
  ps:setLifetime(2.5)
  ps:setEmissionRate(65)
  ps:setDirection(0)
  ps:setSpread(math.tau)
  ps:setParticleLife(3.25)
  ps:setRotation(0, math.tau)
  ps:setSizes(0.8, 0.6)
  ps:setSpeed(9)
  self.particles = ps
  self.particles:start()
end

function Smoke:added()
  self:setupBody()
  self.fixture = self:addShape(love.physics.newRectangleShape(self.width, self.height))
  self.fixture:setSensor(true)
  self.fixture:setCategory(15)
  playRandom{assets.sfx.smoke1, assets.sfx.smoke2}
end

function Smoke:update(dt)
  if self.speedTimer > 0 then
    self.speedTimer = self.speedTimer - dt
    dt = dt + (dt * 3 * (self.speedTimer / self.speedTime))
  end
  
  self.particles:update(dt)
  
  if self.dead then
    if self.particles:count() == 0 then self.world = nil end
    return
  end
  
  PhysicalEntity.update(self, dt)
  
  if self.timer > 0 then
    self.timer = self.timer - dt
  else
    self:die()
  end
end

function Smoke:die()
  self.fixture:destroy()
  self.fixture = nil
  self.dead = true
end

function Smoke:draw()
  if not self.dead then
    --love.graphics.setColor(0, 255, 0, 150)
    --love.graphics.rectangle("fill", self.x - self.width / 2, self.y - self.height / 2, self.width, self.height)
  end
  
  love.graphics.setColor(255, 255, 255)
  love.graphics.draw(self.particles, self.x, self.y)
end
