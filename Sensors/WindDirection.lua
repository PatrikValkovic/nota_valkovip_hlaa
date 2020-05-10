local sensorInfo = {
	name = "WindDirection",
	desc = "Get direction of the wind",
	author = "PatrikValkovic",
	date = "2020-05-10",
	license = "MIT",
}

local EVAL_PERIOD_DEFAULT = 0
function getInfo()
	return {
		period = EVAL_PERIOD_DEFAULT 
	}
end

return function(radius)
	local dirX, dirY, dirZ, strength, normDirX, normDirY, normDirZ = Spring.GetWind()
  local norm = math.sqrt(dirX * dirX + dirZ * dirZ)
  return {
    x = dirX / norm,
    z = dirZ / norm,
  }
end