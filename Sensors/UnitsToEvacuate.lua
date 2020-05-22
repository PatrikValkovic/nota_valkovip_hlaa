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
local GetUnitDefID = Spring.GetUnitDefID

local function inside(what, where)
  for i=1, #where do
    if what == where[i] then
      return true
    end
  end
  return false
end


return function(types)
	local myTeamID = Spring.GetMyTeamID()
  local allunits = GetTeamUnits(myTeamID)
  
  local toevacuate = {}
  
  for _, unitid in pairs(allunits) do
    local unitdefid = GetUnitDefID(unitid)
    local deftable = UnitDefs[unitdefid]
    if inside(deftable.name, types) then
      toevacuate[#toevacuate + 1] = unitid
    end
  end
  
  return toevacuate
end