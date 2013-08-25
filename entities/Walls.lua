Walls = class("Walls", PhysicalEntity)

function Walls:initialize(xml, width, height)
  PhysicalEntity.initialize(self, 0, 0, "static")
  self.layer = 1
  self.width = width
  self.height = height
  self.map = Tilemap:new(assets.images.tiles, TILE_SIZE, TILE_SIZE, width, height)
  self.map.usePositions = true
  self.xml = xml
  self.color = { 200, 200, 200 }
end

function Walls:added()
  self:setupBody()
  if self.xml then self:loadFromXML(self.xml) end
end

function Walls:loadFromXML(xml)
  local elem = findChild(xml, "walls")
  
  for _, v in ipairs(findChildren(elem, "tile")) do
    self.map:set(tonumber(v.attr.x), tonumber(v.attr.y), tonumber(v.attr.id) + 1)
  end
  
  for _, v in ipairs(findChildren(elem, "rect")) do
    self.map:setRect(
      tonumber(v.attr.x),
      tonumber(v.attr.y),
      tonumber(v.attr.w),
      tonumber(v.attr.h),
      tonumber(v.attr.id) + 1
    )
  end
  
  elem = findChild(xml, "collision")
  
  for _, v in ipairs(findChildren(elem, "rect")) do
    local w, h = tonumber(v.attr.w), tonumber(v.attr.h)
    self:addShape(love.physics.newRectangleShape(tonumber(v.attr.x) + w / 2, tonumber(v.attr.y) + h / 2, w, h))
  end
end

function Walls:draw()
  love.graphics.setColor(self.color)
  self.map:draw(self.x, self.y)
end
