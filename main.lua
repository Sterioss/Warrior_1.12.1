function Combat()

  if not HasBuff("player", "BattleShout") and Rage() > 10
  and castable("target", "Battle Shout") then
    return CastSpellByName("Battle Shout")
  end

  if not HasDebuff("target", "Rend") and castable("Rend", "target")
  and Rage() > 10 then
    return CastSpellByName("Rend")
  end
end

function Resting()
end
