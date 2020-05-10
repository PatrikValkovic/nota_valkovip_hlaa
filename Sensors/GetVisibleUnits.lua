local sensorInfo = {
	name = "GetVisibleUnits",
	desc = "Get units in radius",
	author = "PatrikValkovic",
	date = "2020-05-07",
	license = "MIT",
}

local EVAL_PERIOD_DEFAULT = -1
function getInfo()
	return {
		period = EVAL_PERIOD_DEFAULT 
	}
end

return function(radius)
	local unitId = units[1]
	local x, _, z = Spring.GetUnitPosition(unitId)
	local around = Spring.GetUnitsInCylinder(x,z,radius)
	return around
end