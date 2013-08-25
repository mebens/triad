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
    [-1] = 0, -- HUD
    [0] = 1, -- smoke
    [1] = 1, -- walls
    [2] = 1, -- weak walls
    [3] = 1, -- player
    [4] = 1, -- replayers
    [5] = 1, -- turrets
    [6] = 1, -- projectile
    [7] = 1, -- effects
    [8] = 1, -- floor 
  }
end

function LevelBase:loadCommonObjects(active)
  --local obj = findChild(self.xml, "objects")
  local tiled = findChild(self.xml, "tiledObjects")
  
  if tiled then  
    for _, v in ipairs(findChildren(tiled, "weakWall")) do
      self:add(WeakWall:fromXML(v))
    end
  end
end
