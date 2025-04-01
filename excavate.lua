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

		if math.floor(num) ~= num then
			printError("Argument wasn't a whole number")
			return
		end
	end
end

local x = tonumber(args[1])
-- local y = tonumber(args[2])
local z = tonumber(args[3])

---comment
---@param width number
---@return boolean
---@return string?
local function destroyForward(width)
	for _ = 1, width, 1 do
		local ok, msg = turtle.dig()
		if not ok and msg ~= "Nothing to dig here" then
			return false, msg
		end
		ok, msg = turtle.forward()
		if not ok then
			return false, msg
		end

		if fuel.shouldFuel() then
			ok, msg = fuel.fuelUp()
			if not ok then
				return false, msg
			end
		end
	end
	return true
end

local function move(direction, amount)
	for _ = 1, length, 1 do
		local ok, msg = turtle.dig()
		if not ok and msg ~= "Nothing to dig here" then
			return false, msg
		end
		ok, msg = turtle.forward()
		if not ok then
			return false, msg
		end

		if fuel.shouldFuel() then
			ok, msg = fuel.fuelUp()
			if not ok then
				return false, msg
			end
		end
	end
	return true
end

---comment
---@param times number
---@param dir string
---@return boolean
---@return string?
local function digTurnDir(times, dir)
	if dir == "right" then
		for _ = 1, times, 1 do
			local ok, msg = turtle.dig()
			if not ok and msg ~= "Nothing to dig here" then
				return false, msg
			end
			ok, msg = turtle.forward()
			if not ok then
				return false, msg
			end
			ok, msg = turtle.turnRight()
			if not ok then
				return false, msg
			end
		end
	elseif dir == "left" then
		for _ = 1, times, 1 do
			local ok, msg = turtle.dig()
			if not ok and msg ~= "Nothing to dig here" then
				return false, msg
			end
			ok, msg = turtle.forward()
			if not ok then
				return false, msg
			end
			ok, msg = turtle.turnLeft()
			if not ok then
				return false, msg
			end
		end
	else
		return false, "Incorrect direction"
	end

	return true
end

---@param current string
local function flipDirection(current)
	if current == "left" then
		return "right"
	else
		return "left"
	end
end

---@param length any
---@param width any
---@return boolean
---@return string?
local function clearLevel(length, width)
	local ok, msg = destroyForward(math.floor(length / 2) - 1)
	if not ok then
		return false, msg
	end

	ok, msg = digTurnDir(1, "left")
	if not ok then
		return false, msg
	end

	local dir = "left"

	for _ = 1, math.floor(length / 2) * 2, 1 do
		ok, msg = destroyForward(width - 2)
		if not ok then
			return false, msg
		end
		ok, msg = digTurnDir(2, dir)
		dir = flipDirection(dir)

		if not ok then
			return false, msg
		end
	end

	ok, msg = destroyForward(width - 2)
	if not ok then
		return false, msg
	end

	ok, msg = turtle.dig()
	if not ok and msg ~= "Nothing to dig here" then
		return false, msg
	end

	for _ = 1, z - 2, 1 do
		ok, msg = turtle.back()
		if not ok then
			return false, msg
		end
	end

	ok, msg = turtle.turnRight()
	if not ok then
		return false, msg
	end

	for _ = 1, math.floor(length / 2), 1 do
		ok, msg = turtle.forward()
		if not ok then
			return false, msg
		end
	end

	return true
end

local ok, msg = digTurnDir(1, "right")
if not ok then
	printError(msg)
	return
end

clearLevel(x, z)
