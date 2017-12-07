local updateRate = .1
local debugTime = nil

local getUpdateRate()
  if GetFramerate() < 30 then
    updateRate = 0.2
  end
  if GetFramerate > 50 then
    updateRate = 0.1
  end
end

local function onUpdate(self,elapsed)
  debugTime = GetTime()
  self.lastUpdate = self.lastUpdate + elapsed
  if self.lastUpdate > updateRate then
    if not UnitAffectingCombat("player") then
      Resting()
    end
    if UnitAffectingCombat("player") then
      Combat()
    end
  end
  debugTime = GetTime() - debugTime -- Time it took to update
end
