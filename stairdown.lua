---@diagnostic disable:undefined-global
local fuel = require("fuel")
local args = { ... }

if #args ~= 1 then
	printError("Incorrect amount of arguments")
	return
else
	for _, arg in ipairs(args) do
		local num = tonumber(arg)
		if num == nil then
			printError("Argument wasn't a number")
			return
		end

		if math.floor(num) ~= num then
			printError("Argument wasn't a whole number")
			return
		end
	end
end

local function clearRow()
	local ok, msg = turtle.digDown()
	if not ok and msg ~= "Nothing to dig here" then
		return false, msg
	end

	ok, msg = turtle.down()
	if not ok then
		return false, msg
	end

	ok, msg = turtle.dig()
	if not ok and msg ~= "Nothing to dig here" then
		return false, msg
	end

	for _ = 1, 2, 1 do
		ok, msg = turtle.forward()
		if not ok then
			return false, msg
		end

		ok, msg = turtle.dig()
		if not ok and msg ~= "Nothing to dig here" then
			return false, msg
		end

		if fuel.shouldFuel() then
			ok, msg = fuel.fuelUp()
			if not ok then
				return false, msg
			end
		end
	end

	turtle.back()
	if not ok then
		return false, msg
	end
end

local y = tonumber(args[1])
if y == nil then
	y = 1
end

for _ = 1, y, 1 do
	clearRow()
end
