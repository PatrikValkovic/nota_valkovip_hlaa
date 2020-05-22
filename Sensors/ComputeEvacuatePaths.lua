-- SOURCE: https://gist.github.com/LukeMS/89dc587abd786f92d60886f4977b1953
--[[  Priority Queue implemented in lua, based on a binary heap.
Copyright (C) 2017 Lucas de Morais Siqueira <lucas.morais.siqueira@gmail.com>
License: zlib
  This software is provided 'as-is', without any express or implied
  warranty. In no event will the authors be held liable for any damages
  arising from the use of this software.
  Permission is granted to anyone to use this software for any purpose,
  including commercial applications, and to alter it and redistribute it
  freely, subject to the following restrictions:
  1. The origin of this software must not be misrepresented; you must not
     claim that you wrote the original software. If you use this software
     in a product, an acknowledgement in the product documentation would be
     appreciated but is not required.
  2. Altered source versions must be plainly marked as such, and must not be
     misrepresented as being the original software.
  3. This notice may not be removed or altered from any source distribution.
]]--

local function priorityqueue() 
  local floor = math.floor
  local PriorityQueue = {}
  PriorityQueue.__index = PriorityQueue
  setmetatable(
      PriorityQueue,
      {
          __call = function (self)
              setmetatable({}, self)
              self:initialize()
              return self
          end
      }
  )
  function PriorityQueue:initialize()
      --[[  Initialization.
      Example:
          PriorityQueue = require("priority_queue")
          pq = PriorityQueue()
      ]]--
      self.heap = {}
      self.current_size = 0
  end
  function PriorityQueue:empty()
      return self.current_size == 0
  end
  function PriorityQueue:size()
      return self.current_size
  end
  function PriorityQueue:swim()
      -- Swim up on the tree and fix the order heap property.
      local heap = self.heap
      local floor = floor
      local i = self.current_size

      while floor(i / 2) > 0 do
          local half = floor(i / 2)
          if heap[i][2] < heap[half][2] then
              heap[i], heap[half] = heap[half], heap[i]
          end
          i = half
      end
  end
  function PriorityQueue:put(v, p)
      --[[ Put an item on the queue.
      Args:
          v: the item to be stored
          p(number): the priority of the item
      ]]--
      --

      self.heap[self.current_size + 1] = {v, p}
      self.current_size = self.current_size + 1
      self:swim()
  end
  function PriorityQueue:sink()
      -- Sink down on the tree and fix the order heap property.
      local size = self.current_size
      local heap = self.heap
      local i = 1

      while (i * 2) <= size do
          local mc = self:min_child(i)
          if heap[i][2] > heap[mc][2] then
              heap[i], heap[mc] = heap[mc], heap[i]
          end
          i = mc
      end
  end
  function PriorityQueue:min_child(i)
      if (i * 2) + 1 > self.current_size then
          return i * 2
      else
          if self.heap[i * 2][2] < self.heap[i * 2 + 1][2] then
              return i * 2
          else
              return i * 2 + 1
          end
      end
  end
  function PriorityQueue:pop()
      -- Remove and return the top priority item
      local heap = self.heap
      local retval = heap[1][1]
      heap[1] = heap[self.current_size]
      heap[self.current_size] = nil
      self.current_size = self.current_size - 1
      self:sink()
      return retval
  end
  return PriorityQueue
end






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
local Height = Spring.GetGroundHeight

return function(fromunit, tox, toz, grid)
  local fromx, fromy, fromz = GetUnitPosition(fromunit)  
  local step = 256
  local mapX = Game.mapSizeX
  local mapZ = Game.mapSizeZ
  
  -- get closest points
  local closest_from_x
  local closest_from_z
  local closest_from_distance = math.huge
  local closest_to_x
  local closest_to_z
  local closest_to_distance = math.huge
  for z, ztable in pairs(grid) do
    for x, _ in pairs(ztable) do
      local dist_from = distance(fromx, fromz, x, z)
      local dist_to = distance(tox, toz, x, z)
      if dist_from < closest_from_distance then
        closest_from_distance = dist_from
        closest_from_x = x
        closest_from_z = z
      end
      if dist_to < closest_to_distance then
        closest_to_distance = dist_to
        closest_to_x = x
        closest_to_z = z
      end
    end
  end
  
  local path = {
    {x=fromx, y=fromy+25, z=fromz},
    {x=closest_from_x, y=Height(closest_from_x, closest_from_z)+25, z=closest_from_z},
  }
  
  
  -- Dijkstra
  local queue = priorityqueue()()
  queue:put({x=closest_from_x, z=closest_from_z, dist=0, parent=nil}, 0)
  local visited = {}
  local found = false
  local to_process
  while not found and queue:size() > 0 do
    to_process = queue:pop()
    local already_processed = visited[to_process.z] and visited[to_process.z][to_process.x] 
    if not already_processed then
      if to_process.x == closest_to_x and to_process.z == closest_to_z then
        found = true
      else
        local visitedztable = visited[to_process.z] or {} --visit node
        visitedztable[to_process.x] = true
        visited[to_process.z]=visitedztable
        local following = {                       -- define children
          {x=to_process.x-step, z=to_process.z},
          {x=to_process.x+step, z=to_process.z},
          {x=to_process.x, z=to_process.z-step},
          {x=to_process.x, z=to_process.z+step},
        }
        for _, follow in pairs(following) do    -- traverse children
          local isvalid = grid[follow.z] and grid[follow.z][follow.x]
          if isvalid then
            follow.dist = to_process.dist + 1 - grid[follow.z][follow.x] + 0.001
            follow.parent = to_process
            queue:put(follow, follow.dist)
          end
        end
      end
    end
  end
  
  -- backtrack
  if found then
    local backway = {}
    while to_process.parent do
      backway[#backway + 1] = {x=to_process.x, y=Height(to_process.x, to_process.z), z=to_process.z}
      to_process = to_process.parent
    end
    
    for i = 1, #backway do
      path[#path + 1] = backway[#backway - i + 2]
    end
  end
  

  path[#path + 1] = {x=closest_to_x, y=Height(closest_to_x, closest_to_z)+25, z=closest_to_z}
  path[#path + 1] = {x=tox, y=Height(tox, toz)+25, z=toz}
  return path
end