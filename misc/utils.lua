function table.copy(t)
  local ret = {}
  for k, v in pairs(t) do ret[k] = v end
  return setmetatable(ret, getmetatable(t))
end

function getMouse()
  return love.mouse.getX() / postfx.scale, love.mouse.getY() / postfx.scale
end

function getRectImage(width, height, r, g, b, a)
  r = r or 255
  g = g or 255
  b = b or 255
  a = a or 255
  
  local data = love.image.newImageData(width, height)
  data:mapPixel(function() return r, g, b, a end)
  return love.graphics.newImage(data)
end

function drawArc(x, y, r, angle1, angle2, segments)
  local i = angle1
  local j = 0
  local step = math.tau / segments
  
  while i < angle2 do
    j = angle2 - i < step and angle2 or i + step
    love.graphics.line(x + (math.cos(i) * r), y - (math.sin(i) * r), x + (math.cos(j) * r), y - (math.sin(j) * r))
    i = j
  end  
end

function drawCrosshair()
  local mx, my = getMouse()
  local imgW = assets.images.crosshair:getWidth()
  local imgH = assets.images.crosshair:getHeight()
  
  love.graphics.storeColor()
  love.graphics.setColor(20, 20, 20)
  love.graphics.draw(assets.images.crosshair, mx, my, 0, 1, 1, imgW / 2, imgH / 2)
  love.graphics.setColor(255, 255, 255)
  love.graphics.draw(assets.images.crosshair, mx - 1, my - 1, 0, 1, 1, imgW / 2, imgH / 2)
end

function playRandom(sounds, volume, pan)
  local sound = sounds[math.random(1, #sounds)]
  return sound:play(volume, pan)
end

function Entity:drawImage(image, x, y)
  image = image or self.image
  if self.color then love.graphics.setColor(self.color) end
  
  love.graphics.draw(
    image,
    x or self.x,
    y or self.y,
    self.angle,
    self.scaleX or self.scale or 1,
    self.scaleY or self.scale or 1,
    image:getWidth() / 2,
    image:getHeight() / 2
  )
end
