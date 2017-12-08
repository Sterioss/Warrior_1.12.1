function Combat()
  local spellId = GetSpellId("Rend")
  local texture = GetSpellTexture(spellId, "BOOKTYPE_SPELL")
  if not UnitExists("target") then
    if not LastCheck then LastCheck = GetTime() + 0.5 end
    local NextCheck = GetTime()
    if NextCheck - LastCheck >= 0.5 then
      for i=1,5 do
        TargetNearestEnemy()
        if CheckInteractDistance("target", 3) then
          break
        else
          ClearTarget()
        end
      end
      LastCheck = GetTime()
    end
  else
    if CheckInteractDistance("target", 3) then
      EnableAttack()
    end
  end

  if not HasBuff("player", "BattleShout") and Rage() >= 10
  and castable("target", "Battle Shout") then
    return CastSpellByName("Battle Shout")
  end

  if HasDebuff("target", texture) == false and Rage() >= 10
  and castable("target", "Rend")
  and UnitCreatureType("target") ~= "Mechanical" then
    return CastSpellByName("Rend")
  end

  if not lastHS then lastHS = 0 end
  if Rage() >= (25 - HasTalent(1,1)) and castable("target", "Heroic Strike")
  and GetTime() - lastHS >= 1.5 then
    lastHS = GetTime()
    return CastSpellByName("Heroic Strike")
  end
end

function Resting()
end
