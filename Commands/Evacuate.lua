function getInfo()
	return {
		tooltip = "Move each unit individually",
		parameterDefs = {
			{ 
				name = "evacuation_plan",
				variableType = "expression",
				componentType = "editBox",
				defaultValue = "{}",
			},
			{ 
				name = "safetygrid",
				variableType = "expression",
				componentType = "editBox",
				defaultValue = "{}",
			},
      { 
				name = "evac_area",
				variableType = "expression",
				componentType = "editBox",
				defaultValue = "{}",
			},
		}
	}
end

local function distance(fromx, fromy, tox, toy)
  return math.sqrt(math.pow(fromx - tox, 2) + math.pow(fromy - toy, 2))
end

local GetUnitPosition = Spring.GetUnitPosition
local GetUnitTransporter = Spring.GetUnitTransporter
local GetUnitIsTransporting = Spring.GetUnitIsTransporting
local GiveOrderToUnit = Spring.GiveOrderToUnit --(unitid, CMD.MOVE, {target_x, target_y, target_z}, {})

function Run(self, _, parameter)
  local plan = parameter.evacuation_plan
  local safetygrid = parameter.safetygrid
  local area = parameter.evac_area
  
  for evacuator, evacuee in pairs(plan) do
    local is_loaded = GetUnitIsTransporting(evacuator) ~= nil and #GetUnitIsTransporting(evacuator) > 0
    if is_loaded and not self[evacuator] then
      GiveOrderToUnit(evacuator, CMD.UNLOAD_UNITS, {area.center.x, area.center.y, area.center.z, area.radius}, {})
      self[evacuator] = true
    elseif is_loaded then
      -- pass
    else
      GiveOrderToUnit(evacuator, CMD.LOAD_UNITS, {evacuee}, {})
      self[evacuator] = nil
    end
  end
  
  return RUNNING
end
