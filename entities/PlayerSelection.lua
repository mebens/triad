PlayerSelection = class("PlayerSelection", Entity)

function PlayerSelection.static:fromXML(e)
  return PlayerSelection:new(
    tonumber(e.attr.x) + Player.width / 2,
    tonumber(e.attr.y) + Player.height / 2,
    tonumber(e.attr.type)
  )
end

function PlayerSelection:initialize(x, y, type)
  Entity.initialize(self, x, y)
  self.layer = 2
  self.width = Player.width
  self.height = Player.height
  self.image = assets.images.player
  self.type = type
end

function PlayerSelection:update(dt)
  if not self.played then
    local mx, my = getMouse()
    
    self.mouseOver = mx > self.x - self.width / 2
      and my > self.y - self.height / 2
      and mx < self.x + self.width / 2
      and my < self.y + self.height / 2
    
    if self.mouseOver and mouse.pressed.l then self.world:beginWave(self) end
  end
end

function PlayerSelection:draw()
  if self.played then
    love.graphics.setColor(255, 0, 0, 200)
    self.scale = 1
  elseif self.mouseOver then
    love.graphics.setColor(255, 255, 255, 255)
    self.scale = 1.2
  else
    love.graphics.setColor(255, 255, 255, 150)
    self.scale = 1
  end
  
  self:drawImage()
end
