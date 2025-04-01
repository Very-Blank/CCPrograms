---@diagnostic disable:undefined-global
local fuel = require("fuel")
local args = { ... }

if #args ~= 3 then
	printError("Incorrect amount of arguments")
	return
else
	for _, arg in ipairs(args) do
		local num = tonumber(arg)
		if num == nil then
			printError("Argument wasn't a number")
			return
		end

		if math.floor(num) == num then
			printError("Argument wasn't a whole number")
			return
		end
	end
end

-- local x = tonumber(args[1])
-- local y = tonumber(args[2])
local z = tonumber(args[3])

local function destroyForward()
	for _ = 1, z, 1 do
		turtle.dig()
	end
end

if fuel.shouldFuel() then
	local succeeded, err = fuel.fuelUp()
	if succeeded then
		printError(err)
	end
end

destroyForward()
