local sensorInfo = {
	name = "AggregateUnitsWithPositions",
	desc = "Accepts list of positions and list of unit groups, returns list of units where each unit has attached position.",
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

return function(positions, unitsgroups)
  local result = {}
  for group, groupunits in ipairs(unitsgroups) do
    for _, unit in ipairs(groupunits) do
      result[#result + 1] = {
        unit=unit,
        x=positions[group].x,
        z=positions[group].z,
      }
    end
  end
  
  return result
end