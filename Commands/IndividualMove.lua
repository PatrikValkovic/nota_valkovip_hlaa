function getInfo()
	return {
		tooltip = "Move each unit individually",
		parameterDefs = {
			{ 
				name = "units",
				variableType = "expression",
				componentType = "editBox",
				defaultValue = "{}",
			},
      { 
				name = "Fail on death immediately",
				variableType = "expression",
				componentType = "checkBox",
				defaultValue = "false",
			},
      { 
				name = "Fail on death",
				variableType = "expression",
				componentType = "checkBox",
				defaultValue = "false",
			},
		}
	}
end

local function distance(fromx, fromy, tox, toy)
  return math.sqrt(fromx * fromx + fromy * fromy)
end

local function deepcopy(orig)
  local orig_type = type(orig)
  local copy
  if orig_type == 'table' then
      copy = {}
      for orig_key, orig_value in next, orig, nil do
          copy[deepcopy(orig_key)] = deepcopy(orig_value)
      end
      setmetatable(copy, deepcopy(getmetatable(orig)))
  else -- number, string, boolean, etc
      copy = orig
  end
  return copy
end   


local original_moves = nil
function Run(self, _, parameter)
  local moves = parameter.units
  local failimmediately = parameter['Fail on death immediately']
  local failondeath = parameter['Fail on death']
  
  local all_reached = true
  local some_dead = false
  
  if not original_moves then
    original_moves = deepcopy(moves)
  else
    moves = original_moves
  end
  
  --return #moves
  ---[[

  for _, entry in ipairs(moves) do
    local target_x = entry.x
    local target_z = entry.z
    local target_y = Spring.GetGroundHeight(target_x, target_z)
    local unitid = entry.unit

    if Spring.GetUnitIsDead(unitid) == true or Spring.GetUnitIsDead(unitid) == nil then
      some_dead = true
    else
      local unit_x, _, unit_z = Spring.GetUnitPosition(unitid)
      local distance_to_target = distance(unit_x, unit_z, target_x, target_z)
      if distance_to_target > 64 then
        all_reached = false
        Spring.GiveOrderToUnit(unitid, CMD.MOVE, {target_x, target_y, target_z}, {})
      end
    end
  end
  
  ---[[
  if some_dead and failimmediately then
    return FAILURE
  elseif all_reached and some_dead and failondeath then
    return FAILURE
  elseif all_reached then
    return SUCCESS
  else
    return RUNNING
  end
  --]]
end
