data = {}
data.file = "data"

function data.init()
  data.level = 0
  
  if love.filesystem.exists(data.file) then
    local fileData = love.filesystem.read(data.file)
    data.level = tonumber(fileData)
  end
end

function data.save()
  love.filesystem.write(data.file, tostring(data.level))
end

function data.levelComplete(index)
  data.level = math.max(data.level, index)
  data.save()
end
