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
    updateRate = 0.05
  end
  return updateRate
end

function CombatLog(self, event,...)
  if event == "CHAT_MSG_SPELL_SELF_DAMAGE" then
    if string.find(arg1, "Your Overpower hits (.+) for (%d+).") then
      return 0
    end
  end
end

chat = CreateFrame("Frame")
chat:RegisterEvent("CHAT_MSG_SPELL_SELF_DAMAGE")
chat:SetScript("OnEvent", CombatLog)

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

function HasTalent(tab, number)
  name, icon, tier, column, currentRank = GetTalentInfo(tab, number)
  return currentRank
end

function EnableAttack()
  if not AttackAction then
    for i = 1, 120 do
      if IsAttackAction(i) then
        AttackAction = i
      end
    end
  end
  if AttackAction then
    if not IsCurrentAction(AttackAction) then
      UseAction(AttackAction)
    end
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
  return false
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
  if (TimeSinceLastUpdate > getUpdateRate()) then
    if UnitAffectingCombat("player") == 1 then
      Combat()
    end
    TimeSinceLastUpdate = 0
    TimeAfterLastUpdate = GetTime()
  end
  debugTime = GetTime() - debugTime -- Time it took to update
end

local UpdateFrame = CreateFrame("Frame", nil)
UpdateFrame:SetScript("OnUpdate",Warrior_onUpdate)
UpdateFrame:RegisterEvent("OnUpdate")
