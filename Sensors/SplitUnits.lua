local sensorInfo = {
	name = "SplitUnits",
	desc = "Split units into specified number of groups.",
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

local function pick_unit(available_units, threshold, unitsdefs)
  local best_lower = 0
  local best_lower_cost = -math.huge
  local best_upper = 0
  local best_upper_cost = math.huge
  for i = 1, #available_units do
    local unitindex = available_units[i]
    local unitdef = unitsdefs[unitindex]
    
    if unitdef.cost <= threshold and unitdef.cost > best_lower_cost then
      best_lower_cost = unitdef.cost
      best_lower = i
    end
    
    if unitdef.cost > threshold and unitdef.cost < best_upper_cost then
      best_upper_cost = unitdef.cost
      best_upper = i
    end
  end
  
  if best_lower > 0 then
    return available_units[best_lower], best_lower
  else
    return available_units[best_upper], best_upper
  end
  
end


return function(groups)
  -- query units
  local _units = units
  local n_units = #_units
  
  -- query units defs
  local unitsdefs = {}
  for _, unitid in ipairs(_units) do
    local unitdefid = Spring.GetUnitDefID(unitid)
    unitsdefs[#unitsdefs + 1] = UnitDefs[unitdefid]
  end
  
  -- compute average cost per group
  local total_cost = 0
  for _, unitdef in ipairs(unitsdefs) do
    total_cost = total_cost + unitdef.cost
  end
  local average_cost = total_cost / groups
  
  -- create empty groups
  local unit_groups = {}
  for _ = 1, groups do
    unit_groups[#unit_groups + 1] = {cost=0}
  end
  
  -- temp variable with available units
  local available_units = {}
  for k, _ in ipairs(unitsdefs) do
    available_units[k]=k
  end
  
  -- split units into groups
  for units_to_process = 1, n_units do
    local group_to_assign = unit_groups[units_to_process % groups + 1]
    local picked_unit, available_index = pick_unit(available_units, average_cost - group_to_assign.cost, unitsdefs)
    group_to_assign[#group_to_assign + 1] = _units[picked_unit]
    group_to_assign.cost = group_to_assign.cost + unitsdefs[picked_unit].cost
    table.remove(available_units, available_index)
  end
  
  return unit_groups
end