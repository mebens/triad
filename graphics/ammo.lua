-- ammo support

function love.graphics.setMode(width, height, fullscreen, vsync, fsaa)
  local success, result = pcall(
    love.graphics.oldSetMode,
    width * effects._scale,
    height * effects._scale,
    fullscreen,
    vsync,
    fsaa
  )
  
  if success then
    if result then
      love.graphics.width = width
      love.graphics.height = height
    end
    
    effects.reset()
    return result
  else
    error(result, 2)
  end
end
