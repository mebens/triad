MenuItem = class("MenuItem", Entity)

function MenuItem:initialize(title, callback, callbackSelf)
  Entity.initialize(self)
  self.title = title
  self.callback = callback
  self.callbackSelf = callbackSelf
  self.activated = false
  
  self.text = Text:new{
    title,
    align = "center",
    font = assets.fonts.main[16],
    width = love.graphics.width,
    color = { 255, 255, 255, 230 },
    shadow = true
  }
  
  self.width = self.text.fontWidth
  self.height = self.text.fontHeight
end

function MenuItem:draw()
  if not self.menu.active then return end
  self.text:draw(self.menu.x + self.x, self.menu.y + self.y)
end

function MenuItem:selected()
  self.callback(self.callbackSelf)
end

function MenuItem:activate()
  if self.colorTween then self.colorTween:stop() end
  self.colorTween = tween(self.text.color, 0.1, { [4] = 255 })
  self.activated = true
end

function MenuItem:deactivate()
  if self.colorTween then self.colorTween:stop() end
  self.colorTween = tween(self.text.color, 0.1, { [4] = 230 })
  self.activated = false
end
