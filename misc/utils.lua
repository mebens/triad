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
