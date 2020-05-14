local sensorInfo = {
	name = "FindHills",
	desc = "Find hills (place above `minhillsize`) on the map. Samples terrain using `stepsize`.",
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

return function(minhillsize, stepsize)
  stepsize = stepsize or 128
  local heights = Sensors.nota_valkovip_hlaa.ScanHeights(stepsize)
  
  -- get points above minhillsize
  local higher_points = {}
  local cur_x = heights.info.abs.x_min
  local cur_z = heights.info.abs.z_min
  while cur_z < heights.info.abs.z_max do
    cur_x = heights.info.abs.x_min
    while cur_x < heights.info.abs.x_max do
      if heights.abs[cur_z][cur_x] > minhillsize then
        higher_points[#higher_points+1] = {x=cur_x, z=cur_z}
      end
      cur_x = cur_x + heights.info.abs.x_step
    end
    cur_z = cur_z + heights.info.abs.z_step
  end
  
  -- aggregate higher points to hills
  local max_distance = math.sqrt(2 * stepsize * stepsize + 1)
  local hills = {}
  for _, point in pairs(higher_points) do -- for all higher points
    local is_assign = false
    for _, hill in pairs(hills) do -- iterate over parsed hills
      if not is_assign then
        for hillpointindex = 1, #hill do -- for all points on hill
          local distance = math.sqrt(math.pow(hill[hillpointindex].x - point.x, 2) + math.pow(hill[hillpointindex].z - point.z, 2))
          if distance < max_distance then -- if distance < max distance
            hill[#hill + 1] = point -- assign point to the hill
            is_assign = true
          end
        end
      end
    end
    if not is_assign then
      hills[#hills + 1] = {point}
    end
  end
  -- remove duplicates
  for _, hill in pairs(hills) do -- for each hill
    for pointindex = #hill, 1, -1 do -- try each point from back
      for before = 1, pointindex-1 do
        if hill[pointindex] and hill[pointindex].x == hill[before].x and hill[pointindex].z == hill[before].z then
          table.remove(hill, pointindex)
        end
      end
    end
  end
  -- compute center
  for _, hill in pairs(hills) do
    local sum = {
      x = 0,
      z = 0,
    }
    for _, point in pairs(hill) do
      sum.x = sum.x + point.x
      sum.z = sum.z + point.z
    end
    hill.center = {
      x = math.floor(sum.x / #hill),
      z = math.floor(sum.z / #hill),
    }
  end
  
  -- obtain centers
  local hillpoints = {}
  for _, hill in pairs(hills) do
    hillpoints[#hillpoints+1] = hill.center
  end
  
  return hillpoints
end