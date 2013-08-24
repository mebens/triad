Player = class("Player", PhysicalEntity)
Player.static.width = 8
Player.static.height = 15
Player.static.mousePosTime = 0.2

function Player.static:fromXML(e)
  return Player:new(tonumber(e.attr.x) + Player.width / 2, tonumber(e.attr.y) + Player.height / 2, tonumber(e.attr.type))
end

function Player:initialize(x, y, type)
  PhysicalEntity.initialize(self, x, y, "dynamic")
  self.layer = 2
  self.width = Player.width
  self.height = Player.height
  self.speed = 1800
  self.health = 4
  self.type = type
  self.image = assets.images.player
  self.color = { 255, 255, 255 }
  
  self.bulletDeviation = math.tau / 128
  self.pelletDeviation = math.tau / 12
  self.pelletCount = 6
  self.mgFireRate = 0.1
  self.psFireRate = 0.1
  self.sgFireRate = 0.4
  self.weaponTimer = 0
  
  self.mousePosTimer = 0
  self.inputDown = {}
  self.inputLog = {}
  self.angleLog = {}
end

function Player:added()
  self:setupBody()
  self.fixture = self:addShape(love.physics.newRectangleShape(self.width, self.height))
  self.fixture:setCategory(2)
  self.fixture:setMask(2)
  self:setMass(1)
  self:setLinearDamping(10)
  
  if self.world.allPlayers then
    table.insert(self.world.allPlayers, self)
    self.allIndex = #self.world.allPlayers
  end
end

function Player:removed()
  if self.world.allPlayers then
    PhysicalEntity.removed(self)
    table.remove(self.world.allPlayers, self.allIndex)
  end
end

function Player:update(dt)
  PhysicalEntity.update(self, dt)
  self:handleInput(dt)
  
  local dir = self:getDirection()
  if dir then self:applyForce(self.speed * math.cos(dir), self.speed * math.sin(dir)) end
  
  if self.weaponTimer > 0 then
    self.weaponTimer = self.weaponTimer - dt
  elseif self.type == 1 then
    if self.inputDown.fire then
      self.weaponTimer = self.weaponTimer + self.mgFireRate
      self:fireBullet()
    end
  end
  
  -- temporary class changes
  if key.pressed["1"] then self.type = 1 end
  if key.pressed["2"] then self.type = 2 end
  if key.pressed["3"] then self.type = 3 end
end

function Player:draw()
  self:drawImage()
end

function Player:handleInput(dt)
  self.angle = math.angle(self.x, self.y, getMouse())
  self.angle = math.floor(self.angle * 20 + .5) / 20
  
  if self.mousePosTimer < 0 then
    self.angleLog[#self.angleLog + 1] = self.angle
    self.mousePosTimer = Player.mousePosTime
  else
    self.mousePosTimer = self.mousePosTimer - dt
  end
  
  for _, v in pairs{"left", "right", "up", "down", "fire", "ability"} do
    if input.pressed(v) then
      self.inputDown[v] = true
      self.inputLog[#self.inputLog + 1] = { self.world.elapsed, v, "pressed" }
    elseif input.released(v) then
      self.inputDown[v] = false
      self.inputLog[#self.inputLog + 1] = { self.world.elapsed, v, "released" }
    end
  end
  
  if input.pressed("fire") then self:handleSemiAutoFire() end
  if input.pressed("ability") then self:handleAbility() end
end

function Player:handleSemiAutoFire()
  if self.weaponTimer > 0 then return end
  
  if self.type == 2 then
    self:fireBullet()
    self.weaponTimer = self.weaponTimer + self.psFireRate
  elseif self.type == 3 then
    for i = 1, self.pelletCount do
      self.world:add(Pellet:new(
        self.x,
        self.y,
        self.angle - self.pelletDeviation / 2 + self.pelletDeviation * math.random()
      ))
    end
    
    self.weaponTimer = self.weaponTimer + self.sgFireRate
  end
end

function Player:handleAbility()
  if self.abilityUsed then return end
  
  if self.type == 1 then
    
  elseif self.type == 2 then
    
  elseif self.type == 3 then
    self.world:add(Rocket:new(self.x, self.y, self.angle))
    self.abilityUsed = true
  end
end 

function Player:die()
  print(self.health)
end

function Player:damage(amount)
  self.health = self.health - amount
  if self.health <= 0 then self:die() end
end

function Player:fireBullet()
  self.world:add(Bullet:new(self.x, self.y, self.angle - self.bulletDeviation / 2 + self.bulletDeviation * math.random()))
end

function Player:getDirection()
  local xAxis = 0
  local yAxis = 0
  
  if self.inputDown.left then xAxis = xAxis - 1 end
  if self.inputDown.right then xAxis = xAxis + 1 end
  if self.inputDown.up then yAxis = yAxis - 1 end
  if self.inputDown.down then yAxis = yAxis + 1 end
  
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
