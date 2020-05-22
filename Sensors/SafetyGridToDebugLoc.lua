local sensorInfo = {
	name = "SafetyGridToDebugLoc",
	desc = "Turns safety grid into locations that can be printed by debug.",
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

return function(safetygrid)
  local result = {}
  for z, ztable in pairs(safetygrid) do
    for x, prob in pairs(ztable) do
      result[#result + 1] = {x, 0, z, c=prob}
    end
  end
  
  return result
end
