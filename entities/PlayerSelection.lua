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
  self.width = Player.width * 1.5
  self.height = Player.height * 1.5
  self.type = type
  self.alpha = 255
  
  if self.type == 1 then
    self.image = assets.images.playerMg
    self.usedImage = assets.images.playerMgUsed
  elseif self.type == 2 then
    self.image = assets.images.playerPs
    self.usedImage = assets.images.playerPsUsed
  elseif self.type == 3 then
    self.image = assets.images.playerSg
    self.usedImage = assets.images.playerSgUsed
  end
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
    love.graphics.setColor(255, 255, 255, math.max(0, self.alpha - 55))
    self.scale = 1
    self:drawImage(self.usedImage)
  else
    if self.mouseOver then
      love.graphics.setColor(255, 255, 255, self.alpha)
      self.scale = 1.2
    else
      love.graphics.setColor(255, 255, 255, math.max(0, self.alpha - 105))
      self.scale = 1
    end
  
    self:drawImage()
  end
end
