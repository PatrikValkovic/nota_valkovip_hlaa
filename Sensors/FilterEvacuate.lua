local sensorInfo = {
	name = "FilterEvacuate",
	desc = "Filter all the evacuate units and return only those that should be evacuated right now.",
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

local function distance(firstx, firstz, secondx, secondz)
  return math.sqrt(math.pow(firstx - secondx, 2) + math.pow(firstz - secondz, 2))
end

local GetUnitPosition = Spring.GetUnitPosition
local GetUnitTransporter = Spring.GetUnitTransporter
local GetUnitIsDead = Spring.GetUnitIsDead


return function(toevacuate, evacuate_area)
  local new_evacuate = {}
  
  for i = 1, #toevacuate do
    local unitid = toevacuate[i]
    local isalive = not GetUnitIsDead(unitid)
    if isalive then
      local x, _, z = GetUnitPosition(unitid)
      if x and z then
        local dist = distance(x, z, evacuate_area.center.x, evacuate_area.center.z)
        local isTransporting = GetUnitTransporter(toevacuate[i]) ~= nil
        if dist > evacuate_area.radius and not isTransporting then
          new_evacuate[#new_evacuate + 1] = toevacuate[i]
        end
      end
    end
  end
  
  return new_evacuate  
end