local sensorInfo = {
	name = "DegreesBetweenVectors",
	desc = "Get number of degress between two two-dimensional vectors.",
	author = "PatrikValkovic",
	date = "2020-05-11",
	license = "MIT",
}

local EVAL_PERIOD_DEFAULT = -1
function getInfo()
	return {
		period = EVAL_PERIOD_DEFAULT 
	}
end


return function(first_x, first_y, second_x, second_y)
  if not first_x or not first_y or not second_x or not second_y then
    return math.huge
  end
  local firstlen = math.sqrt(first_x * first_x + first_y * first_y)
  local secondlen = math.sqrt(second_x * second_x + second_y * second_y)
  return math.deg(
    math.acos(
      (first_x * second_x + first_y * second_y) / (firstlen * secondlen)
    )
  )
end