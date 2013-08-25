Player = class("Player", PhysicalEntity)
Player.static.width = 7
Player.static.height = 9
Player.static.recordTime = 1 / 100
Player.static.particle = getRectImage(2, 2)

function Player.static:fromXML(e)
  return Player:new(tonumber(e.attr.x) + Player.width / 2, tonumber(e.attr.y) + Player.height / 2, tonumber(e.attr.type))
end

function Player:initialize(x, y, type)
  PhysicalEntity.initialize(self, x, y, "dynamic")
  self.layer = 3
  self.width = Player.width
  self.height = Player.height
  self.speed = 1800
  self.shieldSpeed = 800
  self.shieldMaxHealth = 200
  self.shieldHealth = self.shieldMaxHealth
  self.health = 2
  self.movementAngle = 0
  self.type = type
  self.color = { 255, 255, 255 }
  self.legsMap = Spritemap:new(assets.images.playerLegs, 11, 10)
  self.legsMap:add("move", { 1, 2, 3, 4, 3, 2, 1, 5, 6, 7, 8, 7, 6, 5 }, 35, true)
  
  if self.type == 1 then
    self.image = assets.images.playerMg
  elseif self.type == 2 then
    self.image = assets.images.playerPs
    self.shieldImg = assets.images.playerShield
    self.shield = false
  elseif self.type == 3 then
    self.image = assets.images.playerSg
  end
    
  self.bulletDeviation = math.tau / 128
  self.pelletDeviation = math.tau / 10
  self.pelletCount = 6
  self.mgFireRate = 0.1
  self.psFireRate = 0.1
  self.sgFireRate = 0.4
  self.weaponTimer = 0
  
  self.recordTimer = 0
  self.inputDown = {}
  self.inputLog = {}
  self.posLog = {}
end

function Player:added()
  self:setupBody()
  self.fixture = self:addShape(love.physics.newRectangleShape(self.width, self.height))
  self.fixture:setCategory(2)
  self.fixture:setMask(2)
  self:setMass(1)
  self:setLinearDamping(10)
  if self.world.allPlayers then self.world.allPlayers:push(self) end
end

function Player:removed()
  PhysicalEntity.removed(self)
  if self.world.allPlayers then self.world.allPlayers:remove(self) end
end

function Player:update(dt)
  PhysicalEntity.update(self, dt)
  self.legsMap:update(dt)
  self:handleInput(dt)
  self:setAngularVelocity(0)
  
  if self.weaponTimer > 0 then
    self.weaponTimer = self.weaponTimer - dt
  elseif self.type == 1 then
    if self.inputDown.fire then
      self.weaponTimer = self.weaponTimer + self.mgFireRate
      self:fireBullet()
      playRandom{assets.sfx.shoot1, assets.sfx.shoot2, assets.sfx.shoot3}
    end
  end
end

function Player:draw()
  self.legsMap:draw(self.x, self.y, self.movementAngle, 1.2, 1.2, self.legsMap.width / 2, self.legsMap.height / 2)
  
  if self.shield then
    local ratio = self.shieldHealth / self.shieldMaxHealth
    
    if ratio < 0.75 then
      local gb = math.scale(ratio, 0, 0.75, 0, 220)
      love.graphics.setColor(220, gb, gb)
    else
      love.graphics.setColor(220, 220, 220)
    end
    
    drawArc(self.x, self.y, math.sqrt(self.width ^ 2 + self.height ^ 2) * 0.625, 0, math.tau * ratio, 15)
    self:drawImage(self.shieldImg)
  else
    self:drawImage()
  end
end

function Player:handleInput(dt)
  self.angle = math.angle(self.x, self.y, getMouse())
  self.angle = math.floor(self.angle * 20 + .5) / 20
  
  local dir = self:getDirection()
  local speed = self.shield and self.shieldSpeed or self.speed
  if dir then self:applyForce(speed * math.cos(dir), speed * math.sin(dir)) end
  self.movementAngle = dir or self.angle
  self:handleAnimation(dir)
  
  if self.recordTimer < 0 then
    self.posLog[#self.posLog + 1] = { self.world.elapsed, self.x, self.y, self.angle, dir }
    self.recordTimer = Player.recordTime
  else
    self.recordTimer = self.recordTimer - dt
  end
  
  for _, v in pairs{"fire", "ability"} do
    if input.pressed(v) then
      self.inputDown[v] = true
      self.inputLog[#self.inputLog + 1] = { self.world.elapsed, v, "pressed", getMouse() }
    elseif input.released(v) then
      self.inputDown[v] = false
      self.inputLog[#self.inputLog + 1] = { self.world.elapsed, v, "released" }
    end
  end
  
  if input.pressed("fire") then self:handleSemiAutoFire() end
  if input.pressed("ability") then self:handleAbility(getMouse()) end
end

function Player:handleAnimation(moving)
  if moving then
    if self.legsMap.current ~= "move" then self.legsMap:play("move") end
  else
    self.legsMap:stop()
    self.legsMap.frame = 1
  end
end 

function Player:handleSemiAutoFire()
  if self.weaponTimer > 0 then return end
  
  if self.type == 2 then
    self:fireBullet()
    self.weaponTimer = self.weaponTimer + self.psFireRate
    playRandom{assets.sfx.shoot1, assets.sfx.shoot2, assets.sfx.shoot3}
  elseif self.type == 3 then
    for i = 1, self.pelletCount do
      self.world:add(Pellet:new(
        self.x,
        self.y,
        self.angle - self.pelletDeviation / 2 + self.pelletDeviation * math.random()
      ))
    end
    
    self.weaponTimer = self.weaponTimer + self.sgFireRate
    playRandom{assets.sfx.shotgun1, assets.sfx.shotgun2}
  end
end

function Player:handleAbility(mx, my)
  if self.abilityUsed then return end
  
  if self.type == 1 then
    self.world:add(Smoke:new(mx, my))
    self.abilityUsed = true
  elseif self.type == 2 then
    self.shield = not self.shield
  elseif self.type == 3 then
    self.world:add(Rocket:new(self.x + 10 * math.cos(self.angle), self.y + 10 * math.sin(self.angle), self.angle))
    self.abilityUsed = true
  end
end 

function Player:die()
  self:explode()
  self.world = nil
  self.dead = true
  playRandom{assets.sfx.death1, assets.sfx.death2}
  
  if not instanceOf(Replayer, self) then
    self.deathTime = self.world.elapsed
    self.world:endWave()
  end
end

function Player:explode()
  for i = 1, 10 do
    local g = math.random(20, 70)
    self.world:add(Chunk:new(Player.particle, nil, self.x, self.y, math.tau * math.random(), { g, g, g }, 1, 1.5))
  end
  
  for i = 1, 7 do
    local g = math.random(20, 70)
    self.world:add(Chunk:new(Player.particle, nil, self.x, self.y, math.tau * math.random(), { 210, 0, 0 }, 0.75, 1))
  end
end

function Player:closeInputs()
  for k, v in pairs(self.inputDown) do
    self.inputLog[#self.inputLog + 1] = { self.world.elapsed, k, "released" }
  end
end

function Player:damage(amount)
  self.health = self.health - amount
  if self.health <= 0 then self:die() end
  if self.colorTween and self.colorTween.active then self.colorTween:stop() end
  
  self.colorTween = tween(self.color, 0.25, { 255, 0, 0 }, nil, function()
    tween(self.color, 0.25, { 255, 255, 255 })
  end)
end

function Player:bulletHit(bullet)
  local damage = true
  
  if self.shield then
    local bp = Vector:new(bullet.x - 10 * math.cos(bullet.angle), bullet.y - 10 * math.sin(bullet.angle))
    local pos = (bp - self.pos):normalized()
    local facing = Vector:new(math.cos(self.angle), math.sin(self.angle))
    local angle = math.acos(facing * pos)
    
    if angle < math.tau * 0.19444 then
      damage = false
      self.shieldHealth = self.shieldHealth - bullet.damage
      playRandom{assets.sfx.shield1, assets.sfx.shield2, assets.sfx.shield3}
      
      if self.shieldHealth <= 0 then
        self.shield = false
        self.abilityUsed = true
      end
    end
  end
  
  if damage then
    self:damage(bullet.damage)
    playRandom{assets.sfx.hit1, assets.sfx.hit2}
  end
end

function Player:fireBullet()
  local posAngle = self.angle + math.tau / 4 -- gun pos compensation
  
  self.world:add(Bullet:new(
    self.x + math.cos(posAngle) + math.cos(self.angle) * self.width / 2,
    self.y + math.sin(posAngle) + math.sin(self.angle) * self.height / 2,
    self.angle - self.bulletDeviation / 2 + self.bulletDeviation * math.random()
  ))
end

function Player:getDirection()
  local xAxis = input.axisDown("left", "right")
  local yAxis = input.axisDown("up", "down")
  
  local xAngle = xAxis == 1 and 0 or (xAxis == -1 and math.tau / 2 or nil)
  local yAngle = yAxis == 1 and math.tau / 4 or (yAxis == -1 and math.tau * 0.75 or nil)
  
  if xAngle and yAngle then
    -- x = 1, y = -1 is a special case the doesn't fit; not sure what I can do about it other than this:
    if xAxis == 1 and yAxis == -1 then return yAngle + math.tau / 8 end
    return (xAngle + yAngle) / 2
  else
    return xAngle or yAngle
  end
end
