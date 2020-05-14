local sensorInfo = {
	name = "ScanHeights",
	desc = "Scan the map and returns table with surface heights. Field `abs` is indexed by the real coordinates, field `rel` by the relative coordinates by the step size.",
	author = "PatrikValkovic",
	date = "2020-05-14",
	license = "MIT",
}

local EVAL_PERIOD_DEFAULT = -1
function getInfo()
	return {
		period = EVAL_PERIOD_DEFAULT 
	}
end

return function(step)
  step = math.floor(step)
  local mapX = Game.mapSizeX
  local mapZ = Game.mapSizeZ
	local currentX = math.floor(step / 2)
  local currentZ = math.floor(step / 2)
  local heights = {
    abs = {},
    rel = {},
  }
  while currentZ < mapZ do
    heights.abs[currentZ] = {}
    heights.rel[math.floor(currentZ / step)] = {}
    currentX = math.floor(step / 2)
    while currentX < mapX do
      local height = Spring.GetGroundHeight(currentX, currentZ)
      heights.abs[currentZ][currentX] = height
      heights.rel[math.floor(currentZ / step)][math.floor(currentX / step)] = height
      currentX = currentX + step
    end
    currentZ = currentZ + step
  end
  heights.info = {
    abs = {
      x_min = math.floor(step / 2),
      x_max = currentX-step,
      x_step = step,
      z_min = math.floor(step / 2),
      z_max = currentZ-step,
      z_step = step,
    },
    rel = {
      x_min = 0,
      x_max = math.floor((currentX - step)/ step),
      x_step = 1,
      z_min = 0,
      z_max = math.floor((currentZ - step)/ step),
      z_step = 1,
    },
  }
  return heights
end