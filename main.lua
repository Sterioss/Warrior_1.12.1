
function Combat()
  if not HasDebuff("target", "Rend") and castable("Rend", "target")
  and Rage() > 10 then
    return CastSpellByName("Rend")
  end
  if 
end

function Resting()
end
