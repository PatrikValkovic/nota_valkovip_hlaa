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
      { 
				name = "stepsize",
				variableType = "expression",
				componentType = "editBox",
				defaultValue = "128",
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
local GetUnitIsDead = Spring.GetUnitIsDead

function Run(self, _, parameter)
  local plan = parameter.evacuation_plan
  local safetygrid = parameter.safetygrid
  local area = parameter.evac_area
  local stepsize = parameter.stepsize
  for evacuator, evacuee in pairs(plan) do
    local isalive = not GetUnitIsDead(evacuator) and not GetUnitIsDead(evacuee)
    if isalive then

      if not self[evacuator] then
        self[evacuator] = {state=0, prevstate=-1, same=0}
      end
      
      if self[evacuator].state == 0 then -- just assigned command
        local is_loaded = GetUnitIsTransporting(evacuator) ~= nil and #GetUnitIsTransporting(evacuator) > 0
        if not is_loaded then
          self[evacuator].state = 1
        else
          self[evacuator].state = 10
        end
      end
      
      if self[evacuator].state == 1 then -- should plan for pickup
        local tarx, _, tarz = GetUnitPosition(evacuee)
        local path = Sensors.ComputeEvacuatePaths(evacuator, tarx, tarz, safetygrid, stepsize)
        for i = 1, #path do
          local modify = {}
          if i ~= 1 then modify = {"shift"} end
          GiveOrderToUnit(evacuator, CMD.MOVE, {path[i].x, path[i].y, path[i].z}, modify)
        end
        self[evacuator].target = path[#path]
        self[evacuator].state = 2
      end
      
      if self[evacuator].state == 2 then -- on the way to pickup
        local target_x = self[evacuator].target.x
        local target_z = self[evacuator].target.z
        local curx, _, curz = GetUnitPosition(evacuator)
        local dist = distance(curx, curz, target_x, target_z)
        if dist < 100 then
          self[evacuator].state = 3
        end
      end
      
      if self[evacuator].state == 3 then -- close to the pickup
        GiveOrderToUnit(evacuator, CMD.LOAD_UNITS, {evacuee}, {})
        self[evacuator].state = 4
      end
      
      if self[evacuator].state == 4 then -- picking up
        local is_loaded = GetUnitIsTransporting(evacuator) ~= nil and #GetUnitIsTransporting(evacuator) > 0
        if is_loaded then
          self[evacuator].state = 10
        end
      end

      
      if self[evacuator].state == 10 then -- carry something, should plan way back
        local path = Sensors.ComputeEvacuatePaths(evacuator, area.center.x, area.center.z, safetygrid, stepsize)
        for i = 1, #path do
          local modify = {}
          if i ~= 1 then modify = {"shift"} end
          GiveOrderToUnit(evacuator, CMD.MOVE, {path[i].x, path[i].y, path[i].z}, modify)
        end
        self[evacuator].target = path[#path]
        self[evacuator].state = 11
      end
      
      if self[evacuator].state == 11 then -- on the way to safety
        local target_x = self[evacuator].target.x
        local target_z = self[evacuator].target.z
        local curx, _, curz = GetUnitPosition(evacuator)
        local dist = distance(curx, curz, target_x, target_z)
        if dist < 100 then
          self[evacuator].state = 12
        end
      end
      
      if self[evacuator].state == 12 then -- close to the drop position
        GiveOrderToUnit(evacuator, CMD.UNLOAD_UNITS, {area.center.x, area.center.y, area.center.z, area.radius}, {})
        self[evacuator].state = 13
      end
      
      if self[evacuator].state == 13 then -- droping
        local is_loaded = GetUnitIsTransporting(evacuator) ~= nil and #GetUnitIsTransporting(evacuator) > 0
        if not is_loaded then
          self[evacuator].state = 0
        end
      end
      
      
      --handle stuck
      if self[evacuator].same > 20 then
        self[evacuator].state = 0
      end
      if self[evacuator].state == self[evacuator].prevstate then
        self[evacuator].same = self[evacuator].same + 1
      else
        self[evacuator].prevstate = self[evacuator].state
        self[evacuator].same = 0
      end
    
    end
  end
  
  return RUNNING
end
