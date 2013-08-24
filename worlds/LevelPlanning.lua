LevelPlanning = class("LevelPlanning", LevelBase)

function LevelPlanning:initialize(name)
  local xmlFile = love.filesystem.read("assets/levels/" .. name .. ".oel")
  LevelBase.initialize(self, slaxml:dom(xmlFile).root)
  self.name = tostring(name)
  self.playerSelections = {}
  self.turrets = {}
  
  local obj = findChild(self.xml, "objects")
  
  for _, v in ipairs(findChildren(obj, "player")) do
    local p = PlayerSelection:fromXML(v)
    self.playerSelections[#self.playerSelections + 1] = p
    self:add(p)
  end
  
  for _, v in ipairs(findChildren(obj, "turret")) do
    local t = Turret:fromXML(v)
    t.active = false
    self.turrets[#self.turrets + 1] = t
    self:add(t)
  end
end

function LevelPlanning:beginWave(selection)
  self.selection = selection
  selection.played = true
  ammo.world = LevelWave:new(self)
end

function LevelPlanning:endWave(player)
  ammo.world = self
  
  if self.finalReplay then
  else
    local done = true
    
    for _, v in ipairs(self.playerSelections) do
      if not v.played then done = false end
    end
    
    self.selection.inputLog = player.inputLog
    self.selection.posLog = player.posLog
    self.selection = nil
    
    if done then
      self.finalReplay = true
      ammo.world = LevelWave:new(self)
    end
  end
end
