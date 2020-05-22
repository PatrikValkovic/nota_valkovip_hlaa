local sensorInfo = {
	name = "ScanSafety",
	desc = "Scan the map and returns probability that the place is safe.",
	author = "PatrikValkovic",
	date = "2020-05-22",
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

local EnemyPositions = Sensors.nota_valkovip_hlaa.EnemyPositions
local GetPositionLosState = Spring.GetPositionLosState
local GetGroundHeight = Spring.GetGroundHeight

return function(step, max_enemy_distance)
  max_enemy_distance = max_enemy_distance or 600
  step = math.floor(step)
  local mapX = Game.mapSizeX
  local mapZ = Game.mapSizeZ
	local currentX = math.floor(step / 2)
  local currentZ = math.floor(step / 2)
  local safety = {}
  
  local enemies_positions = EnemyPositions()
  
  while currentZ < mapZ do
    local ztable = {}
    safety[currentZ] = ztable
    currentX = math.floor(step / 2)
    while currentX < mapX do
      
      -- scan enemies around
      local enemy_around = false
      for _, enemy in pairs(enemies_positions) do
        local dist = distance(currentX, currentZ, enemy.x, enemy.z)
        if dist < max_enemy_distance then
          enemy_around = true
          ztable[currentX] = 0
        end
      end
      
      -- scan based on radar
      if not enemy_around then
        local around_points = 0
        local seen_by_radar = 0
        local fromx = math.max(0, currentX - max_enemy_distance)
        local tox = math.min(mapX, currentX + max_enemy_distance)
        local fromz = math.max(0, currentZ - max_enemy_distance)
        local toz = math.min(mapZ, currentZ + max_enemy_distance)
        for curx = fromx, tox, step do
          for curz = fromz, toz, step do
            local dist = distance(currentX, currentZ, curx, curz)
            if dist < max_enemy_distance then
              around_points = around_points + 1
              local cury = GetGroundHeight(curx, curz)
              if GetPositionLosState(curx, cury, curz) then
                seen_by_radar = seen_by_radar + 1
              end
            end
          end
        end
        local prob = seen_by_radar / around_points
        ztable[currentX] = prob
      end
      
      
      currentX = currentX + step
    end
    currentZ = currentZ + step
  end
  
  return safety
end