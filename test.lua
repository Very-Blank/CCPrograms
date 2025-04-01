---@diagnostic disable:undefined-global

---@return boolean, string?
local function fuelUp()
	local is_fuel, _ = turtle.refuel(0)
	if not is_fuel then
		local foundFuel = false
		for slot = 1, 15, 1 do
			turtle.select(slot)
			local isFuel, _ = turtle.refuel(0)
			if isFuel then
				foundFuel = true
				break
			end
		end

		if foundFuel then
			return false, "No fuel"
		end
	end

	local succeeded, err = turtle.refuel()
	if not succeeded then
		return false, err
	end

	return true
end

local function shouldFuel()
	local fuel = turtle.getFuelLevel()
	print(fuel)
	if fuel < 20.0 then
		return true
	else
		return false
	end
end

for _ = 1, 1000, 1 do
	if shouldFuel() then
		fuelUp()
	end

	local succeeded, err = turtle.forward()
	if not succeeded then
		printError(err)
		break
	end
end
