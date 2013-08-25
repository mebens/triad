HUD = class("HUD", Entity)

function HUD:initialize()
  Entity.initialize(self)
  self.layer = 0
  self.timeTxt = Text:new{"10", font = assets.fonts.main[14], shadow = true }
  self.paddingX = 25
  self.paddingY = 12
end

function HUD:added()
  self.timeTxt.color[4] = 0
  tween(self.timeTxt.color, 0.25, { [4] = 255 })
end

function HUD:update(dt)
  if self.world.inWave then self.timeTxt.text = math.ceil(LevelWave.time - self.world.elapsed) end
end

function HUD:draw()
  if not self.world.inWave then return end
  
  self.timeTxt:draw(
    love.graphics.width - self.paddingX - self.timeTxt.fontWidth / 2,
    self.paddingY + self.timeTxt.fontHeight / 2
  )
end
