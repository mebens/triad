MainMenu = class("MainMenu", World)

function MainMenu:initialize()
  World.initialize(self)
  self.padding = 40
  
  self.header = Text:new{
    "Triad",
    y = self.padding,
    width = love.graphics.width,
    align = "center",
    font = assets.fonts.main[24],
    shadow = true
  }
  
  self.instructions = Text:new{
    "Arrows key and space/enter to use menu.",
    width = love.graphics.width,
    align = "center",
    font = assets.fonts.main[8],
    shadow = true
  }
  
  self.instructions.y = love.graphics.height - self.instructions.fontHeight - 20
  self.menu = Menu:new(self.header.fontHeight + self.padding * 2)
  
  if data.level == 0 then
    self.menu:add(MenuItem:new("Play", self.tutorial, self))
  else
    local options = {}
    
    for i = 1, #LevelPlanning.levels do
      if i <= data.level + 1 then options[i] = LevelPlanning.levels[i] end
    end
    
    self.levelSelect = SelectionItem:new("Level", options, self.play, self, math.min(data.level + 1, #LevelPlanning.levels))
    self.menu:add(self.levelSelect)
    self.menu:add(MenuItem:new("Play", self.play, self))
    self.menu:add(MenuItem:new("Tutorial", self.tutorial, self))
  end
  
  self.menu:add(MenuItem:new("Quit", self.quit, self))
  self:add(self.menu)
  self:add(MenuTriangle:new(math.tau / 15, 0.7, 1, 70))
  self:add(MenuTriangle:new(-math.tau / 25, 1.2, 1.5, 110))
end

function MainMenu:start()
  fade.fadeIn()
end

function MainMenu:draw()
  love.graphics.storeColor()
  love.graphics.setColor(15, 15, 15)
  love.graphics.rectangle("fill", 0, 0, love.graphics.width, love.graphics.height)
  love.graphics.resetColor()
  
  World.draw(self)
  self.header:draw()
  self.instructions:draw()
end

function MainMenu:play()
  local index = self.levelSelect.current
  fade.fadeOut(0.5, function() ammo.world = LevelPlanning:new(index) end)
end

function MainMenu:tutorial()
  fade.fadeOut(0.5, function() ammo.world = Tutorial:new() end)
end

function MainMenu:quit()
  love.event.quit()
end
