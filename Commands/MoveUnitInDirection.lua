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
				defaultValue = "0",
			}
		}
	}
end


local function clip(min, max, val)
  return math.max(min, math.min(max, val))
end

function Run(self, unitIds, parameter)
  local max_distance = parameter.max_distance
  local unit = parameter.unit
  local dirX = parameter.dir_x
  local dirZ = parameter.dir_z
  local currentX, _, currentZ = Spring.GetUnitPosition(unit)
      
  local mapX = Game.mapSizeX
  local mapZ = Game.mapSizeZ
  local scaled_norm = math.sqrt(dirX * dirX + dirZ * dirZ) / max_distance
  dirX = dirX / scaled_norm
  dirZ = dirZ / scaled_norm
  local targetX = clip(1, mapX-1, currentX + dirX)
  local targetZ = clip(1, mapZ-1, currentZ + dirZ)
  local targetY = Spring.GetGroundHeight(targetX, targetZ)
  local target_coordinates = {targetX, targetY, targetZ}
  Spring.GiveOrderToUnit(unit, CMD.MOVE, target_coordinates, {})

  return RUNNING

  
end
