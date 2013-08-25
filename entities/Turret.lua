Turret = class("Turret", PhysicalEntity)
Turret.static.width = 11
Turret.static.height = 11
Turret.static.particle = getRectImage(2, 2)

function Turret.static:fromXML(e)
  return Turret:new(
    tonumber(e.attr.x) + Turret.width / 2,
    tonumber(e.attr.y) + Turret.height / 2,
    math.rad(tonumber(e.attr.angle))
  )
end

function Turret:initialize(x, y, angle, ref)
  PhysicalEntity.initialize(self, x, y, "static")
  self.layer = 5
  self.baseImg = assets.images.turretBase
  self.gunImg = assets.images.turretGun
  self.width = self.baseImg:getWidth()
  self.height = self.baseImg:getHeight()
  self.health = 12
  self.fireTimer = 0
  self.planningRef = ref
  self.angle = angle or 0
  self.dead = false
  
  if ref then self.deathTime = ref.deathTime end
  self.fireTime = 0.1
  self.viewLength = 300
  self.angleMoveRate = math.tau * 3
  self.angleFireThreshold = math.tau / 10
end

function Turret:added()
  self:setupBody()
  self.fixture = self:addShape(love.physics.newRectangleShape(self.width, self.height))
  self.fixture:setCategory(3)
  if self.world.allTurrets then self.world.allTurrets:push(self) end
end

function Turret:removed()
  PhysicalEntity.removed(self)
  if self.world.allTurrets then self.world.allTurrets:remove(self) end
end

function Turret:update(dt)
  PhysicalEntity.update(self, dt)
  if self.deathTime and self.world.elapsed >= self.deathTime then self:die() end
  
  if self.target then
    if not self.target.dead and self:inView(self.target) then
      local targetAngle = math.angle(self.x, self.y, self.target.x, self.target.y)
      self.angle = self.angle + math.min(targetAngle - self.angle, self.angleMoveRate * dt)
      
      if self.fireTimer > 0 then
        self.fireTimer = self.fireTimer - dt
      elseif targetAngle - self.angle <= self.angleFireThreshold then
        self.world:add(Bullet:new(self.x, self.y, self.angle, true))
        self.fireTimer = self.fireTimer + self.fireTime
        playRandom{assets.sfx.shoot1, assets.sfx.shoot2, assets.sfx.shoot3}
      end
    else
      self.target = nil
    end
  end
  
  if not self.target then
    local targetDist
    
    for v in self.world.allPlayers:iterate() do
      local dist = self:inView(v)
      
      if dist and (not self.target or dist < targetDist) then
        self.target = v
        targetDist = dist
      end
    end
  end
end

function Turret:draw()
  love.graphics.draw(self.baseImg, self.x, self.y, 0, 1, 1, self.width / 2, self.height / 2)
  self:drawImage(self.gunImg)
end

function Turret:die()
  if self.dead then return end
  self.world = nil
  self.dead = true
  playRandom{assets.sfx.explosion1, assets.sfx.explosion2, assets.sfx.explosion3, assets.sfx.explosion4}
  
  for i = 1, 25 do
    local g = math.random(20, 100)
    self.world:add(Chunk:new(Turret.particle, nil, self.x, self.y, math.tau * math.random(), { g, g, g }))
  end
  
  for i = 1, 7 do
    self.world:add(Chunk:new(Turret.particle, nil, self.x, self.y, math.tau * math.random(), { 255, 210, 0 }))
  end

  if not self.deathTime then
    self.planningRef.deathTime = self.world.elapsed
  end
end

function Turret:damage(amount)
  self.health = self.health - amount
  if self.health <= 0 then self:die() end
end

function Turret:inView(player)
  local ret = false
  local dist = math.distance(self.x, self.y, player.x, player.y)
  
  if dist <= self.viewLength then
    ret = dist
    
    self.world:rayCast(self.x, self.y, player.x, player.y, function(fixture)
      local e = fixture:getUserData()
      
      if instanceOf(Walls, e) or instanceOf(WeakWall, e) or instanceOf(Smoke, e) then
        ret = false
        return 0
      else
        return 1
      end
    end)
  end
  
  return ret
end
