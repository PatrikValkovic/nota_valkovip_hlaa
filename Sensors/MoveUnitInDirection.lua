local sensorInfo = {
	name = "MoveUnitInDirection",
	desc = "Move unit in a specific direction",
	author = "PatrikValkovic",
	date = "2020-05-10",
	license = "MIT",
}

local EVAL_PERIOD_DEFAULT = -1
function getInfo()
	return {
		period = EVAL_PERIOD_DEFAULT 
	}
end

local function clip(min, max, val)
  return math.max(min, math.min(max, val))
end

return function(unit, dirX, dirZ, max_distance)
  max_distance = max_distance or 1000
  local currentX, _, currentZ = Spring.GetUnitPosition(unit)
  local mapX = Game.mapSizeX
  local mapZ = Game.mapSizeZ
  local scaled_norm = math.sqrt(dirX * dirX + dirZ * dirZ) / max_distance
  dirX = dirX / scaled_norm
  dirZ = dirZ / scaled_norm
  local params = {
    clip(1, mapX-1, currentX + dirX), 
    0, 
    clip(1, mapZ-1, currentZ + dirZ),
  }
  Spring.GiveOrderToUnit(unit, CMD.MOVE, params, {})
  return params -- debug
end