LevelPlanning = class("LevelPlanning", LevelBase)

function LevelPlanning:initialize(name)
  local xmlFile = love.filesystem.read("assets/levels/" .. name .. ".oel")
  LevelBase.initialize(self, slaxml:dom(xmlFile).root)
  self.name = tostring(name)
  self:loadObjects(false)
  self.playerSelections = {}
  
  for _, v in ipairs(findChildren(findChild(self.xml, "objects"), "player")) do
    local p = PlayerSelection:fromXML(v)
    self.playerSelections[#self.playerSelections + 1] = p
    self:add(p)
  end
end

function LevelPlanning:beginWave(selection)
  self.selection = selection
  selection.played = true
  ammo.world = LevelWave:new(self)
end

function LevelPlanning:endWave(player)
  ammo.world = self
  self.selection.inputLog = player.inputLog
  self.selection.angleLog = player.angleLog
  self.selection = nil
end
