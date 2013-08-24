Rocket = class("Rocket", PhysicalEntity)
Rocket.static.speed = 300

function Rocket:initialize(x, y, angle)
  PhysicalEntity.initialize(self, x, y, "dynamic")
  self.layer = 5
  self.angle = angle
  self.image = assets.images.rocket
  self.width = self.image:getWidth()
  self.height = self.image:getHeight()
  self.velx = Rocket.speed * math.cos(angle)
  self.vely = Rocket.speed * math.sin(angle)
end

function Rocket:added()
  self:setupBody()
  self.fixture = self:addShape(love.physics.newRectangleShape(self.width, self.height))
  self.fixture:setMask(2)
  self.fixture:setSensor(true)
end

function Rocket:draw()
  self:drawImage()
end

function Rocket:die()
  self.world = nil
end

function Rocket:collided(other, fixture, otherFixture, contact)
  if instanceOf(Turret, other) then
    other:die()
  end
  
  self:die()
  -- TODO: breakable barriers
end
    
