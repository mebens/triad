LevelWave = class("LevelWave", LevelBase)
LevelWave.static.time = 10

function LevelWave:initialize(planning)
  LevelBase.initialize(self, planning.xml)
  self.name = planning.name
  self.width = planning.width
  self.height = planning.height
  self.planning = planning
  self.inWave = true
  self.elapsed = 0
  self.allPlayers = {}
  
  self.hud = HUD:new()
  self:add(self.hud)
  
  local sel = planning.selection
  self.player = Player:new(sel.x, sel.y, sel.type)
  self:add(self.player)
  
  for _, v in ipairs(planning.playerSelections) do
    if v ~= sel and v.played then
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
  PhysicalWorld.update(self, dt)
  
  if self.inWave then
    self.elapsed = self.elapsed + dt
    if self.elapsed >= LevelWave.time then self:endWave() end
  end
end

function LevelWave:endWave()
  self.planning:endWave(self.player)
end
