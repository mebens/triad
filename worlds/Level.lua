Level = class("Level", PhysicalWorld)

function Level:initialize(name)
  PhysicalWorld.initialize(self)
  self.name = tostring(name)
  self.initialized = false
  
  local xmlFile = love.filesystem.read("assets/levels/" .. name .. ".oel")
  self.xml = slaxml:dom(xmlFile).root
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
  
  self:loadObjects()
end

function Level:start()
  if not self.initialized then
    self:setGravity(0, 0)
    self.initialized = true
  end
end

function Level:loadObjects()
  local elem = findChild(self.xml, "objects")
  self.player = Player:fromXML(findChild(elem, "player"))
  self:add(self.player)
  for _, v in ipairs(findChildren(elem, "turret")) do self:add(Turret:fromXML(v)) end
end
