Replayer = class("Replayer", Player)

function Replayer:initialize(x, y, type, inputs, pos, deathTime)
  Player.initialize(self, x, y, type)
  self.color[4] = 150
  self.inputLog = inputs
  self.posLog = pos
  self.inputLogCopy = table.copy(inputs)
  self.posLogCopy = table.copy(pos)
  self.deathTime = deathTime
end

function Replayer:handleInput(dt)
  -- positions/angles
  local moveAngle = false
  
  for i = 1, #self.posLogCopy do
    local log = self.posLogCopy[i]
    
    if log[1] > self.world.elapsed then
      if i > 1 then
        self.x = log[2]
        self.y = log[3]
        self.angle = log[4]
        moveAngle = log[5]
        for i = 1, i - 1 do table.remove(self.posLogCopy, 1) end
      end
      
      break
    end
  end
  
  self.movementAngle = moveAngle or self.angle
  self:handleAnimation(moveAngle)
  
  -- inputs
  if #self.inputLogCopy > 1 then
    local ahead
    
    repeat
      local input = self.inputLogCopy[1]
      if not input then break end
      ahead = input[1] > self.world.elapsed
      
      if not ahead then
        if input[3] == "pressed" then
          self.inputDown[input[2]] = true
          
          if input[2] == "fire" then
            self:handleSemiAutoFire()
          elseif input[2] == "ability" then
            self:handleAbility(input[4], input[5])
          end
        elseif input[3] == "released" then
          self.inputDown[input[2]] = false
        end
        
        table.remove(self.inputLogCopy, 1)
      end
    until ahead
  elseif self.world.elapsed > LevelWave.time then
    self.inputDown = {}
  end
end

function Replayer:die()
  if self.deathTime and self.world.elapsed >= self.deathTime then Player.die(self) end
end
