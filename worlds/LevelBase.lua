LevelBase = class("LevelBase", PhysicalWorld)
LevelBase.static.waveTime = 10

function LevelBase:initialize(xml)
  PhysicalWorld.initialize(self)
  self.xml = xml
  self.width = getText(self.xml, "width")
  self.height = getText(self.xml, "height")
  
  self.floor = Floor:new(self.xml, self.width, self.height)
  self.walls = Walls:new(self.xml, self.width, self.height)
  self:add(self.floor, self.walls)
  
  self:setupLayers{
    [0] = 0, -- HUD
    [1] = 1, -- walls
    [2] = 1, -- player
    [3] = 1, -- replayers
    [4] = 1, -- enemies
    [5] = 1, -- projectile
    [6] = 1, -- effects
    [7] = 1, -- floor 
  }
end

function LevelBase:loadObjects(active)
  local elem = findChild(self.xml, "objects")
  
  for _, v in ipairs(findChildren(elem, "turret")) do
    local e = Turret:fromXML(v) 
    if active == false then e.active = false end
    self:add(e)
  end
end
