function getInfo()
	return {
		onNoUnits = SUCCESS,
		tooltip = "Move unit in a specified direction.",
		parameterDefs = {
			{ 
				name = "unit",
				variableType = "expression",
				componentType = "editBox",
				defaultValue = "0",
			},
      { 
				name = "dir_x",
				variableType = "expression",
				componentType = "editBox",
				defaultValue = "0",
			},
      { 
				name = "dir_z",
				variableType = "expression",
				componentType = "editBox",
				defaultValue = "0",
			},
      { 
				name = "max_distance",
				variableType = "expression",
				componentType = "editBox",
				defaultValue = "1000",
			},
		}
	}
end


local function clip(min, max, val)
  return math.max(min, math.min(max, val))
end

local target_coordinates = nil

function Run(self, unitIds, parameter)
  local max_distance = parameter.max_distance
  local unit = parameter.unit
  local dirX = parameter.dir_x
  local dirZ = parameter.dir_z
  local currentX, _, currentZ = Spring.GetUnitPosition(unit)
      
  if not target_coordinates then
    local currentX, _, currentZ = Spring.GetUnitPosition(unit)
    local mapX = Game.mapSizeX
    local mapZ = Game.mapSizeZ
    local scaled_norm = math.sqrt(dirX * dirX + dirZ * dirZ) / max_distance
    dirX = dirX / scaled_norm
    dirZ = dirZ / scaled_norm
    target_coordinates = {
      clip(1, mapX-1, currentX + dirX), 
      0, 
      clip(1, mapZ-1, currentZ + dirZ),
    }
    Spring.GiveOrderToUnit(unit, CMD.MOVE, target_coordinates, {})
  end
  
  -- TODO problem with refreshing movement when target REACHED - unit just stop there.
  local distance = math.sqrt(math.pow(currentX - target_coordinates[1], 2) + math.pow(currentZ - target_coordinates[3], 2))
  if distance < 100 then
    target_coordinates = nil
    return SUCCESS
  else
    return RUNNING
  end
  
end
