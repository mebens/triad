Floor = class("Floor", Entity)

function Floor:initialize(xml, width, height)
  Entity.initialize(self)
  self.layer = 8
  self.width = width
  self.height = height
  self.map = Tilemap:new(assets.images.tiles, TILE_SIZE, TILE_SIZE, width, height)
  self.map.usePositions = true
  self.color = { 110, 110, 110 }
  if xml then self:loadFromXML(xml) end
end

function Floor:loadFromXML(xml)
  local elem = findChild(xml, "floor")
  
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
end

function Floor:draw()
  love.graphics.setColor(self.color)
  self.map:draw(self.x, self.y)
end
