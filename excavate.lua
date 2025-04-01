---@diagnostic disable:undefined-global
local fuel = require("fuel")
local args = { ... }

if #args ~= 3 then
	printError("Incorrect amount of arguments")
	return
else
	for _, arg in ipairs(args) do
		if type(arg) ~= "number" then
			printError("Argument wasn't a number")
			return
		end

		if math.floor(arg) == arg then
			printError("Argument wasn't a whole number")
			return
		end
	end
end

local function destroyForward()
	for _ = 1, args[3], 1 do
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
