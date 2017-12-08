function Combat()
  texture = GetSpellTexture(GetSpellId("Rend"), "BOOKTYPE_SPELL")
  if not HasBuff("player", "BattleShout") and Rage() >= 10
  and castable("target", "Battle Shout") then
    return CastSpellByName("Battle Shout")
  end

  if not HasDebuff("target", texture) and Rage() >= 10
  and castable("target", "Rend") then
    return CastSpellByName("Rend")
  end
end

function Resting()
end
