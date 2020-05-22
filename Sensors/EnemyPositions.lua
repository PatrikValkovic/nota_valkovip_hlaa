local sensorInfo = {
	name = "EnemyPositions",
	desc = "Returns positions of enemies.",
	author = "PatrikValkovic",
	date = "2020-05-22",
	license = "MIT",
}

local EVAL_PERIOD_DEFAULT = 0 -- cachining results for multiple calls in one AI frame

function getInfo()
	return {
		period = EVAL_PERIOD_DEFAULT
	}
end

local GetUnitPosition = Spring.GetUnitPosition
local EnemyUnits = Sensors.core.EnemyUnits

return function()
  local enemies = EnemyUnits()
  local enemies_positions = {}
  for _, unitid in pairs(enemies) do
    local x, _, z = GetUnitPosition(unitid)
    enemies_positions[#enemies_positions + 1] = {x=x,z=z}
  end
  
  return enemies_positions
end
