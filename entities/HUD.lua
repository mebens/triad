HUD = class("HUD", Entity)

function HUD:initialize()
  Entity.initialize(self)
  self.layer = -1
  self.timeTxt = Text:new{"10", font = assets.fonts.main[16], shadow = true}
  self.message = Text:new{"", font = assets.fonts.main[8], align = "center", shadow = true}
  self.paddingX = 30
  self.paddingY = 12
  self.crosshair = assets.images.crosshair
end

function HUD:added()
  if not self.world.isRepeat then
    self.timeTxt.color[4] = 0
    self.message.color[4] = 0
    tween(self.timeTxt.color, 0.25, { [4] = 255 })
    tween(self.message.color, 0.25, { [4] = 255 })
  end
end

function HUD:update(dt)
  if self.world.inWave then self.timeTxt.text = math.ceil(LevelWave.time - self.world.elapsed) end
  
  if self.world.replay then
    if self.world.planning.allEnemiesKilled then
      self.message.text = "Press space to continue, or press R to restart."
    else
      self.message.text = "Press space or R to restart."
    end
  end
end

function HUD:draw()
  if self.world.replay then
    self.message:draw(0, love.graphics.height - self.paddingY * 3)
  end
  
  if self.world.inWave then
    self.timeTxt:draw(
      love.graphics.width - self.paddingX - self.timeTxt.fontWidth / 2,
      self.paddingY + self.timeTxt.fontHeight / 2
    )
    
    drawCrosshair()
  end
end
