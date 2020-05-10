local sensorInfo = {
	name = "GetUnitsOfType",
	desc = "Get from units passed as argument only units of specific type",
	author = "PatrikValkovic",
	date = "2020-05-10",
	license = "MIT",
}

local EVAL_PERIOD_DEFAULT = -1
function getInfo()
	return {
		period = EVAL_PERIOD_DEFAULT 
	}
end


return function(units, unittype)
  local filtered_units = {}
  for _, unit in pairs(units) do
    if type(unit) == 'number' then
      local unitdefid = Spring.GetUnitDefID(unit)
      if unitdefid ~= nil then
        local realtype = UnitDefs[unitdefid]['name']
        if realtype == unittype then
          filtered_units[#filtered_units+1] = unit
        end
      end
    end
  end
  return filtered_units
end