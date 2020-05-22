local sensorInfo = {
	name = "ComputeEvacuatePaths",
	desc = "Compute evacuate paths.",
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

return function(toevacuate, safetygrid, evacuateposition, evacuate_distance)
  evacuate_distance = evacuate_distance or 500
  
  local relevant_to_evacuate = {}
  for ev_i = 1, #toevacuate do
    local x, _, z = GetUnitPosition(toevacuate[ev_i])
    local dist = distance(x, z, evacuateposition[1], evacuateposition[3])
    if dist < evacuate_distance then
      relevant_to_evacuate[#relevant_to_evacuate + 1] = toevacuate[ev_i]
  end
  local evacuate_positions = {}
  
  local paths = {}
  
  for unit_i = 1, #units do
    
  end
  
  return paths
end