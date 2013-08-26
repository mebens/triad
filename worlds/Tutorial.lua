Tutorial = class("Tutorial", World)

function Tutorial:initialize()
  World.initialize(self)
  self.pages = {}
  self.padding = 30
  self.fadeTime = 0.25
  self.imgColor = { 255, 255, 255, 0 }
  
  self.header = Text:new{
    "",
    x = self.padding,
    y = self.padding,
    width = love.graphics.width - self.padding * 2,
    align = "center",
    font = assets.fonts.main[16],
    { 255, 255, 255, 0 }
  }
  
  self.text = Text:new{
    "",
    x = self.padding,
    y = self.padding * 2,
    width = love.graphics.width - self.padding * 2,
    align = "center",
    font = assets.fonts.main[8],
    { 255, 255, 255, 0 }
  }
  
  self:addPage(nil, "Controls",
    "Move: WASD/Arrow keys",
    "Shoot/Select Soldier: LMB",
    "Use Ability: RMB",
    "Restart: R",
    "Toggle Music: M",
    "Quit: Escape"
  )
  
  self:addPage(nil, "Basics",
    "Your goal: eliminate all hostile defense turrets.",
    "You have three soldiers, each of which you play for 10 seconds. Each soldier overlaps in time with the previously played soldiers. You must use this in order to win.",
    "",
    "Remember, to begin, select a solider with LMB."
  )
  
  self:addPage(assets.images.tutorialMg, "The Gunner",
    "Weapon: Machine Gun",
    "Ability: Smoke screen. Blocks turret's vision of your soldiers. Use RMB to deploy it on the crosshair. Single-use."
  )
  
  self:addPage(assets.images.tutorialPs, "The Shield",
    "Weapon: Pistol",
    "Ability: Bullet-absorbing shield. Only blocks from the front, and can only take a limited amount of damage. Note the shield can be shot over by other soldiers. Use RMB to toggle."
  )
  
  self:addPage(assets.images.tutorialSg, "The Demo",
    "Weapon: Shotgun",
    "Ability: Rocket. Used primarily to destroy weak walls. Use RMB to fire it in the direction of the crosshair. Single-use."
  )
  
  self:addPage(assets.images.tutorialWalls, "Weak Walls",
    "Destroy these with the demo to access other areas or routes. You will need to destroy most of them in order to win."
  )
  
  self:addPage(nil, "Tips",
    "- Once a turret locks onto a target, it won't fire on anything else until it loses sight of the original target.",
    "- Keep moving in a circle and turrets may not hit you.",
    "- First position the shield in front of turrets, then use the gunner to kill them from behind the shield.",
    "- Shooting at weak walls isn't such a bad idea. You can use the demo to destroy them later."
  )
end

function Tutorial:start()
  self:switchPage(1)
  fade.fadeIn(0.5)
end

function Tutorial:update(dt)
  World.update(self, dt)
  
  if key.pressed[" "] then
    if self.current == #self.pages then
      self:toGame()
    else
      self:switchPage(self.current + 1)
    end
  elseif key.pressed["return"] then
    self:toGame()
  end
end

function Tutorial:draw()
  self.header:draw()
  self.text:draw()
  
  if self.image then
    love.graphics.storeColor()
    love.graphics.setColor(self.imgColor)
    love.graphics.draw(self.image, love.graphics.width / 2 - self.image:getWidth() / 2, self.padding * 2)
    love.graphics.resetColor()
  end
end

function Tutorial:addPage(img, header, ...)
  local str = ""
  for _, v in ipairs{...} do str = str .. v .. "\n" end
  self.pages[#self.pages + 1] = { image = img, header = header, text = str }
end

function Tutorial:switchPage(index)
  if self.current then
    self.header.color[4] = 255
    self.text.color[4] = 255
    self.imgColor[4] = 255
    tween(self.text.color, self.fadeTime, { [4] = 0 }, ease.quadIn)
    tween(self.imgColor, self.fadeTime, { [4] = 0 }, ease.quadIn)
    
    tween(self.header.color, self.fadeTime, { [4] = 0 }, ease.quadIn, function()
      self.current = nil
      self:switchPage(index)
    end)
  else
    self.current = index
    self.header.color[4] = 0
    self.text.color[4] = 0
    self.imgColor[4] = 0
    tween(self.header.color, self.fadeTime, { [4] = 255 }, ease.quadOut)
    tween(self.text.color, self.fadeTime, { [4] = 255 }, ease.quadOut)
    tween(self.imgColor, self.fadeTime, { [4] = 255 }, ease.quadOut)
    
    local p = self.pages[index]
    self.header.text = p.header
    self.text.text = p.text .. "\n" .. self.current .. "/" .. #self.pages
    self.text.text = self.text.text .. "\nPress space to continue. Press return to skip tutorial."
    self.image = p.image
    
    if self.image then
      self.text.y = self.padding * 2.5 + self.image:getHeight()
    else
      self.text.y = self.padding * 2
    end
  end
end

function Tutorial:toGame()
  fade.fadeOut(0.5, function() ammo.world = LevelPlanning:new(1) end)
end
