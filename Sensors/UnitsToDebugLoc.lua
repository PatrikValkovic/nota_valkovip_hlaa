local sensorInfo = {
	name = "UnitsToDebugLoc",
	desc = "Show position of units.",
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

return function(u)
  local result = {}
  
  for i = 1, #u do
    local x, _, z = GetUnitPosition(u[i])
    result[#result + 1] = {x, 0, z}
  end
  
  return result
end
