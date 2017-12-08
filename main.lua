function Combat()
  local spellId = GetSpellId("Rend")
  local texture = GetSpellTexture(spellId, "BOOKTYPE_SPELL")

  if not UnitExists("target") then
    if not LastCheck then local LastCheck = GetTime() + 0.5 end
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
  end

  if CheckInteractDistance("target", 3) then
    AutoAttack()
  end

  if not HasBuff("player", "BattleShout") and Rage() >= 10
  and castable("target", "Battle Shout") then
    return CastSpellByName("Battle Shout")
  end

  if HasDebuff("target", texture) == false and Rage() >= 10
  and castable("target", "Rend") then
    return CastSpellByName("Rend")
  end
end

function Resting()
end
