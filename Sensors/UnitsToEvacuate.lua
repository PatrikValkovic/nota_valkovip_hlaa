local sensorInfo = {
	name = "UnitsToEvacuate",
	desc = "Pick up all units that should be evacuated.",
	author = "PatrikValkovic",
	date = "2020-05-22",
	license = "MIT",
}

local EVAL_PERIOD_DEFAULT = -1
function getInfo()
	return {
		period = EVAL_PERIOD_DEFAULT 
	}
end

local GetTeamUnits = Spring.GetTeamUnits

return function()
	local myTeamID = Spring.GetMyTeamID()
  local allunits = GetTeamUnits(myTeamID)
  
  local toevacuate = {}
  
  for _, unitid in pairs(allunits) do
    
  end
  
  return toevacuate
end