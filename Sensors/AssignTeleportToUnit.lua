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

return function(evacuators, evacuatees)
  local evacuations = {}
  
  for eva_i = 1, #evacuators do
    local evacuator_unitid = evacuators[eva_i]
    local isalive = not GetUnitIsDead(evacuator_unitid)
    if isalive then
      local x, _, z = GetUnitPosition(evacuator_unitid)
      local to_evacuate = -1
      local to_evacuate_distance = math.huge
      for i = 1, #evacuatees do
        local evacuatee_unitid = evacuatees[i]
        local ex, _, ez = GetUnitPosition(evacuatee_unitid)
        local dist = distance(ex, ez, x, z)
        if dist < to_evacuate_distance then
          to_evacuate = i
          to_evacuate_distance = dist
        end
      end
      if to_evacuate ~= -1 then
        evacuations[evacuator_unitid] = evacuatees[to_evacuate]
        table.remove(evacuatees, to_evacuate)
      end
    end
  end
  
  return evacuations
end