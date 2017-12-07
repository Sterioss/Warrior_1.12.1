if UnitClass("player") ~= "Warrior" then
  return
end
local updateRate = .1
local debugTime = nil

local function getUpdateRate()
  if GetFramerate() < 30 then
    updateRate = 0.2
  end
  if GetFramerate() > 50 then
    updateRate = 0.1
  end
end

local function GetSpellId(spellname)
  local id = 1
  for i = 1, GetNumSpellTabs() do
    local _, _, _, numSpells = GetSpellTabInfo(i)
    for j = 1, numSpells do
      local spellName = GetSpellName(id, BOOKTYPE_SPELL)
      if (spellName == spellname) then
        return id
      end
      id = id + 1
    end
  end
  return nil
end

local function latency()
  local lagWorld = GetNetStats()
  return lagWorld
end

function SpellOnCD(spellName)
  local id = GetSpellId(spellName)
  if id then
    local start, duration = GetSpellCooldown(id, 0)
    if start == 0 and duration == 0 then
      return nil
    end
  end
  return true
end

function castable(spellName, target)
  if UnitIsUnit("player", target) or UnitIsDead(target)
  or not UnitExists(target) then
    return false
  end
  local start, duration = GetSpellCooldown(61304)
  if start == 0 or duration < latency() then
    return true
  end
end

function HasDebuff(unit, textureName)
  local i = 1
  while UnitDebuff(unit, i) do
    local texture, applications, duration = UnitDebuff(unit, i)
    if string.find(texture, textureName) and duration ~= nil then
      return applications
    end
    i = i + 1
  end
  return 0
end

function HasBuff(unit, textureName)
  local i = 1
  while UnitBuff(unit, i) do
    local texture = UnitBuff(unit, i)
    if string.find(texture, textureName) then
      return true
    end
    i = i + 1
  end
  return false
end

function Rage()
  return UnitMana("player")
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
    self.lastUpdate = 0
  end
  debugTime = GetTime() - debugTime -- Time it took to update
end
