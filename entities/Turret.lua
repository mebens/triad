Turret = class("Turret", PhysicalEntity)
Turret.static.width = 11
Turret.static.height = 11

function Turret.static:fromXML(e)
  return Turret:new(tonumber(e.attr.x) + Turret.width / 2, tonumber(e.attr.y) + Turret.height / 2)
end

function Turret:initialize(x, y, ref)
  PhysicalEntity.initialize(self, x, y, "static")
  self.baseImg = assets.images.turretBase
  self.gunImg = assets.images.turretGun
  self.width = self.baseImg:getWidth()
  self.height = self.baseImg:getHeight()
  self.health = 10
  self.fireTimer = 0
  self.planningRef = ref
  
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
end

function Turret:update(dt)
  PhysicalEntity.update(self, dt)
  if self.deathTime and self.world.elapsed >= self.deathTime then self:die() end
  
  if self.target then
    if self:inView(self.target) then
      local targetAngle = math.angle(self.x, self.y, self.target.x, self.target.y)
      self.angle = self.angle + math.min(targetAngle - self.angle, self.angleMoveRate * dt)
      
      if self.fireTimer > 0 then
        self.fireTimer = self.fireTimer - dt
      elseif targetAngle - self.angle <= self.angleFireThreshold then
        self.world:add(Bullet:new(self.x, self.y, self.angle, true))
        self.fireTimer = self.fireTimer + self.fireTime
      end
    else
      self.target = nil
    end
  end
  
  if not self.target then
    local targetDist
    
    for _, v in ipairs(self.world.allPlayers) do
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
  self.world = nil
  
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
      
      if instanceOf(Walls, e) then
        ret = false
        return 0
      else
        return 1
      end
    end)
  end
  
  return ret
end
