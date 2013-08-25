LevelWave = class("LevelWave", LevelBase)
LevelWave.static.time = 10

function LevelWave:initialize(planning, isRepeat)
  LevelBase.initialize(self, planning.xml)
  self.width = planning.width
  self.height = planning.height
  self.planning = planning
  self.isRepeat = isRepeat 
  self.inWave = true
  self.paused = false
  self.elapsed = 0
  self.allPlayers = LinkedList:new("_playerNext", "_playerPrev")
  self.allTurrets = LinkedList:new("_turretNext", "_turretPrev")
  self.hud = HUD:new()
  self:add(self.hud)
  self:loadCommonObjects()
  
  if planning.selection then
    local sel = planning.selection
    self.player = Player:new(sel.x, sel.y, sel.type)
    self:add(self.player)
  else
    self.replay = true
  end
  
  for _, v in ipairs(planning.playerSelections) do
    if v ~= planning.selection and v.played then
      self:add(Replayer:new(v.x, v.y, v.type, v.inputLog, v.posLog))
    end
  end
  
  for _, v in ipairs(planning.turrets) do
    self:add(Turret:new(v.x, v.y, v))
  end
end

function LevelWave:start()
  self:setGravity(0, 0)
end

function LevelWave:update(dt)
  if key.pressed.t then self.paused = not self.paused end
  if self.paused then return end
  PhysicalWorld.update(self, dt)
  
  if self.inWave then
    self.elapsed = self.elapsed + dt
    
    if self.elapsed >= LevelWave.time or (not self.replay and (self.allPlayers.length < 1 or self.allTurrets.length < 1)) then
      self:endWave()
    end
  end
  
  if self.replay then
    local restart = input.pressed("restart")
    
    if not self.planning.allEnemiesKilled then
      restart = restart or input.pressed("progress")
    elseif input.pressed("progress") then
      self.planning:nextLevel()
    end
    
    if restart then self.planning:restart() end
  end
end

function LevelWave:endWave()
  self.inWave = false
  if self.player then self.player:closeInputs() end
  
  if self.replay then
    ammo.world = LevelWave:new(self.planning, true)
  else
    self.planning:endWave(self.player)
  end
end
