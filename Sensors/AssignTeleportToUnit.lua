local sensorInfo = {
	name = "AssignTeleportToUnit",
	desc = "Assign evacuate airplane to the units",
	author = "PatrikValkovic",
	date = "2020-05-14",
	license = "MIT",
}

local EVAL_PERIOD_DEFAULT = 10
function getInfo()
	return {
		period = EVAL_PERIOD_DEFAULT 
	}
end

local function distance(firstx, firstz, secondx, secondz)
  return math.sqrt(math.pow(firstx - secondx, 2) + math.pow(firstz - secondz, 2))
end

local GetUnitPosition = Spring.GetUnitPosition
local GetUnitIsDead = Spring.GetUnitIsDead

return function(evacuators_original, evacuatees)
  local evacu = {}
  local evacuators = {}
  for i=1, #evacuators_original do
    evacuators[i] = evacuators_original[i]
  end
  
  local tmp = 0
  while #evacuators > 0 and tmp < 1000 do
    tmp = tmp + 1
    local current_evacuator = evacuators[#evacuators]
    evacuators[#evacuators] = nil
    
    local best_evacuee = -1
    local best_distance = math.huge
    
    for i=1, #evacuatees do
      local current_evacuee = evacuatees[i]
      local ex, _, ez = GetUnitPosition(current_evacuee)
      local rx, _, rz = GetUnitPosition(current_evacuator)
      local dist = distance(ex, ez, rx, rz)
      if (not evacu[current_evacuee] and dist < best_distance) or         -- closer to not reserved
         (evacu[current_evacuee] and dist < evacu[current_evacuee].dist)  -- or closer to somebody else
      then
        best_evacuee = current_evacuee
        best_distance = dist
      end
    end
    
    if not evacu[best_evacuee] then
      evacu[best_evacuee] = {evacuator=current_evacuator, dist=best_distance}
    elseif evacu[best_evacuee].evacuator ~= current_evacuator then
      local prev_evacuator = evacu[best_evacuee].evacuator
      evacu[best_evacuee].evacuator = current_evacuator
      evacu[best_evacuee].dist = best_distance
      evacuators[#evacuators + 1] = prev_evacuator
    end
    
  end

  local evacuations = {}
  for evacuee, evatable in pairs(evacu) do
    evacuations[evatable.evacuator] = evacuee 
  end
  
  return evacuations
end