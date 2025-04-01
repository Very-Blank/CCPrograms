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
---@param length number
---@return boolean
---@return string?
local function destroyForward(length)
	for _ = 1, length, 1 do
		local ok, msg = turtle.dig()
		if not ok and msg ~= "Nothing to dig here" then
			return false, msg
		end
		ok, msg = turle.forward()
		if not ok then
			return false, msg
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

if fuel.shouldFuel() then
	local succeeded, err = fuel.fuelUp()
	if succeeded then
		printError(err)
	end
end

local ok, msg = digTurnDir(1, "right")
if not ok then
	printError(msg)
	return
end
ok, msg = destroyForward(math.floor(x / 2))
if not ok then
	printError(msg)
	return
end
ok, msg = digTurnDir(1, "left")
if not ok then
	printError(msg)
	return
end

for _ = 1, 1 + math.floor(x / 2) * 2, 1 do
	ok, msg = destroyForward(z - 2)
	if not ok then
		printError(msg)
		return
	end
	ok, msg = digTurnDir(2, "left")
	if not ok then
		printError(msg)
		return
	end
	ok, msg = destroyForward(z - 2)
	if not ok then
		printError(msg)
		return
	end
	ok, msg = digTurnDir(2, "right")
	if not ok then
		printError(msg)
		return
	end
end
