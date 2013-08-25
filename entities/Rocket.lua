Rocket = class("Rocket", PhysicalEntity)
Rocket.static.speed = 300
Rocket.static.particle = getRectImage(2, 2)

function Rocket:initialize(x, y, angle)
  PhysicalEntity.initialize(self, x, y, "dynamic")
  self.layer = 6
  self.angle = angle
  self.image = assets.images.rocket
  self.width = self.image:getWidth()
  self.height = self.image:getHeight()
  self.velx = Rocket.speed * math.cos(angle)
  self.vely = Rocket.speed * math.sin(angle)
  
  local ps = love.graphics.newParticleSystem(Rocket.particle, 100)
  ps:setDirection(self.angle)-- math.tau / 2)
  ps:setSpread(math.tau / 4)
  ps:setSizes(1, 0.6, 0.2)
  ps:setSpeed(30, 40)
  ps:setParticleLife(0.3, 0.5)
  ps:setColors(255, 210, 0, 255, 255, 60, 0, 0)
  ps:setEmissionRate(100)
  ps:start()
  self.particles = ps
end

function Rocket:added()
  self:setupBody()
  self.fixture = self:addShape(love.physics.newRectangleShape(self.width, self.height))
  self.fixture:setMask(2, 12, 15)
  self.fixture:setSensor(true)
  playRandom{assets.sfx.rocket1, assets.sfx.rocket2}
end

function Rocket:update(dt)
  self.particles:setPosition(self.x, self.y)
  self.particles:update(dt)
  
  if self.dead then
    if self.particles:count() == 0 then self.world = nil end
    return
  end
  
  PhysicalEntity.update(self, dt)
end

function Rocket:draw()
  love.graphics.draw(self.particles)
  if not self.dead then self:drawImage() end
end

function Rocket:die()
  self.dead = true
  self.particles:setEmissionRate(0)
  self.particles:stop()
  playRandom{assets.sfx.explosion1, assets.sfx.explosion2, assets.sfx.explosion3, assets.sfx.explosion4}
  
  for i = 1, 30 do
    self.world:add(Chunk:new(Rocket.particle, nil, self.x, self.y, math.tau * math.random(), { 255, 180, 0 } ))
  end
end

function Rocket:collided(other, fixture, otherFixture, contact)
  if self.dead then return end
  if instanceOf(Bullet, other) then return end
  
  if instanceOf(Turret, other) then
    other:die()
  elseif instanceOf(WeakWall, other) then
    other:die(self.angle)
  end
  
  self:die()
end
    
