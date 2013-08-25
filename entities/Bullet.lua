Bullet = class("Bullet", PhysicalEntity)
Bullet.static.image = getRectImage(7, 1, 255, 240, 0)
Bullet.static.speed = 750

function Bullet:initialize(x, y, angle, enemy)
  PhysicalEntity.initialize(self, x, y, "dynamic")
  self.layer = 5
  self.width = Bullet.image:getWidth()
  self.height = Bullet.image:getHeight()
  self.velx = Bullet.speed * math.cos(angle)
  self.vely = Bullet.speed * math.sin(angle)
  self.angle = angle
  self.enemy = enemy or false
  self.damage = 3
  self.image = Bullet.image
  self.id = {}
end

function Bullet:added()
  self:setupBody()
  self:setBullet(true)
  self.fixture = self:addShape(love.physics.newRectangleShape(self.width, self.height))
  
  if self.enemy then
    self.fixture:setMask(3, 12, 15)
    self.fixture:setCategory(3)
  else
    self.fixture:setMask(2, 12, 15)
    self.fixture:setCategory(2)
  end
  
  self.fixture:setSensor(true)
end

function Bullet:draw()
  self:drawImage()
end

function Bullet:die()
  self.dead = true
  self.world = nil
end

function Bullet:collided(other, fixture, otherFixture, contact)
  if self.dead then return end
  if instanceOf(Bullet, other) or instanceOf(Rocket, other) then return end
  self:die()
  
  if self.enemy then
    if instanceOf(Player, other) then other:bulletHit(self) end
  elseif instanceOf(Turret, other) then
    other:damage(self.damage)
  end
end
