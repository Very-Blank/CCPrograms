---@diagnostic disable:undefined-global
local fuel = require("fuel")
local args = { ... }

if #args ~= 3 then
	error("Incorrect amount of arguments")
	return
else
	for _, arg in ipairs(args) do
		local num = tonumber(arg)
		if num == nil then
			error("Argument wasn't a number")
		end

		if math.floor(num) ~= num then
			error("Argument wasn't a whole number")
		end
	end
end

---@param direction string
---@param amount number
---@return boolean
---@return string?
local function move(direction, amount)
	for _ = 1, amount, 1 do
		local ok, msg = true, nil
		if direction == "forward" then
			turtle.dig()
			if not ok and msg ~= "Nothing to dig here" then
				return false, msg
			end

			ok, msg = turtle.forward()
			if not ok then
				return false, msg
			end
		elseif direction == "down" then
			turtle.digDown()
			if not ok and msg ~= "Nothing to dig here" then
				return false, msg
			end

			ok, msg = turtle.down()
			if not ok then
				return false, msg
			end
		elseif direction == "up" then
			turtle.digUp()
			if not ok and msg ~= "Nothing to dig here" then
				return false, msg
			end

			ok, msg = turtle.up()
			if not ok then
				return false, msg
			end
		else
			return false, "Incorrect direction"
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
	local ok, msg = move("forward", length - 1)
	if not ok then
		return false, msg
	end

	ok, msg = digTurnDir(1, "left")
	if not ok then
		return false, msg
	end

	local dir = "left"

	for _ = 1, length * 2, 1 do
		ok, msg = move("forward", width)
		if not ok then
			return false, msg
		end
		ok, msg = digTurnDir(2, dir)
		dir = flipDirection(dir)

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

	ok, msg = move("forward", width)
	if not ok then
		return false, msg
	end

	ok, msg = turtle.dig()
	if not ok and msg ~= "Nothing to dig here" then
		return false, msg
	end

	for _ = 1, width, 1 do
		ok, msg = turtle.back()
		if not ok then
			return false, msg
		end
	end

	ok, msg = turtle.turnRight()
	if not ok then
		return false, msg
	end

	for _ = 1, length, 1 do
		ok, msg = turtle.forward()
		if not ok then
			return false, msg
		end
	end

	return true
end

local x = tonumber(args[1])
if x == nil then
	x = 1
end
local y = tonumber(args[2])
if y == nil then
	y = 1
end
local z = tonumber(args[3])
if z == nil then
	z = 1
end

if fuel.shouldFuel() then
	local ok, msg = fuel.fuelUp()
	if not ok then
		return false, msg
	end
end

local ok, msg = digTurnDir(1, "right")
if not ok then
	error(msg)
end

ok, msg = move("down", y)
if not ok then
	error(msg)
end

for i = 1, y * 2 + 1, 1 do
	ok, msg = clearLevel(x, z)
	if not ok then
		error(msg)
	end
	if i ~= y * 2 + 1 then
		ok, msg = move("up", 1)
		error(msg)
	end
end
