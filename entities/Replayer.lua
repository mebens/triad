Replayer = class("Replayer", Player)

function Replayer:initialize(x, y, type, inputs, angles)
  Player.initialize(self, x, y, type)
  self.color[4] = 150
  self.inputLog = inputs
  self.angleLog = angles
end

function Replayer:handleInput(dt)
  if #self.inputLog < 1 then return end
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
