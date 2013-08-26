Menu = class("Menu", Entity)

function Menu:initialize(y)
  Entity.initialize(self, 0, y)
  self.items = {}
  self.padding = 5
  self.currentY = 0
end

function Menu:added()
  self.world:add(unpack(self.items))
  self:activate(1)
end

function Menu:update(dt)
  if input.pressed("up") and self.current > 1 then self:activate(self.current - 1) end
  if input.pressed("down") and self.current < #self.items then self:activate(self.current + 1) end
  if input.pressed("menuSelect") then self.items[self.current]:selected() end
end

function Menu:add(item)
  self.items[#self.items + 1] = item
  item.menu = self
  item.y = self.currentY
  self.currentY = self.currentY + item.height + self.padding
end

function Menu:addSpace(height)
  self.currentY = self.currentY + height
end

function Menu:activate(index)
  if self.current then self.items[self.current]:deactivate() end
  self.current = index
  self.items[index]:activate()
end
