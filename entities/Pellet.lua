Pellet = class("Pellet", Bullet)

function Pellet:initialize(x, y, angle)
  Bullet.initialize(self, x, y, angle)
  self.damage = 4
end

function Pellet:added()
  Bullet.added(self)
  self:setLinearDamping(3)
end

function Pellet:update(dt)
  PhysicalEntity.update(self, dt)
  if math.sqrt(self.velx ^ 2 + self.vely ^ 2) < 100 then self:die() end
end
