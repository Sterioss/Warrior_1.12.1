if UnitClass("player") ~= "Warrior" then
  return
end
local updateRate = .1
local debugTime = nil
if TimeSinceLastUpdate == nil then TimeSinceLastUpdate = 0 end
if TimeAfterLastUpdate == nil then TimeAfterLastUpdate = GetTime() end

function getUpdateRate()
  if GetFramerate() < 30 then
    updateRate = 0.2
  end
  if GetFramerate() > 50 then
    updateRate = 0.1
  end
  return updateRate
end

function GetSpellId(spellname)
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

function castable(target, spellName)
  if UnitIsUnit("player", target) or UnitIsDead(target)
  or not UnitExists(target) then
    return false
  elseif SpellOnCD(spellName) then
    return false
  else
    return true
  end
end

function HasDebuff(unit, textureName)
  local i = 1
  while UnitDebuff(unit, i) do
    local texture, icon = UnitDebuff(unit, i)
    if string.find(texture, textureName) then
      return true
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

function Warrior_onUpdate()
  debugTime = GetTime()
  TimeSinceLastUpdate = GetTime() - TimeAfterLastUpdate
  update = getUpdateRate()
  if (TimeSinceLastUpdate > update) then
    if UnitAffectingCombat("player") == 1 then
      Combat()
    end
    TimeSinceLastUpdate = 0
    TimeAfterLastUpdate = GetTime()
  end
  debugTime = GetTime() - debugTime -- Time it took to update
end

local UpdateFrame = CreateFrame("Frame", nil);
UpdateFrame:SetScript("OnUpdate",Warrior_onUpdate);
UpdateFrame:RegisterEvent("OnUpdate");
