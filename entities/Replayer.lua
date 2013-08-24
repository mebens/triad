Replayer = class("Replayer", Player)

function Replayer:initialize(x, y, type, inputs, pos)
  Player.initialize(self, x, y, type)
  self.color[4] = 150
  self.inputLog = inputs
  self.posLog = pos
end

function Replayer:handleInput(dt)
  -- positions/angles
  for i = 1, #self.posLog do
    local log = self.posLog[i]
    
    if log[1] > self.world.elapsed then
      if i > 1 then
        self.x = log[2]
        self.y = log[3]
        self.angle = log[4]
        for i = 1, i - 1 do table.remove(self.posLog, 1) end
      end
      
      break
    end
  end
  
  -- inputs
  if #self.inputLog > 1 then
    local ahead
    
    repeat
      local input = self.inputLog[1]
      if not input then break end
      ahead = input[1] > self.world.elapsed
      
      if not ahead then
        if input[3] == "pressed" then
          self.inputDown[input[2]] = true
          
          if input[2] == "fire" then
            self:handleSemiAutoFire()
          elseif input[2] == "ability" then
            self:handleAbility()
          end
        elseif input[3] == "released" then
          self.inputDown[input[2]] = false
        end
        
        table.remove(self.inputLog, 1)
      end
    until ahead
  end
end

function Replayer:die()
  self.world = nil
end
