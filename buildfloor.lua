---@diagnostic disable:undefined-global
local fuel = require("fuel")
local args = { ... }

if #args ~= 1 then
	printError("Incorrect amount of arguments")
end

local turn = args[1]
if turn == nil then
	printError("Arg was nill")
	return
else
	if turn ~= "left" and turn ~= "right" then
		printError("Incorrect turn direction")
		return
	end
end

local item = turtle.getItemDetail(slot)
if item == nil then
	printError("No Item selected")
	return
end

if fuel.shouldFuel() then
	local ok, msg = fuel.fuelUp()
	if not ok then
		printError(msg)
		return
	end
end

local function selectNewItem()
	for slot = 1, 15, 1 do
		local slotItem = turtle.getItemDetail(slot)
		if slotItem ~= nil then
			if slotItem.name == item.name then
				turtle.select(slot)
				return true
			end
		end
	end

	return false, "No item found"
end

local function placeDown()
	local ok, msg = turtle.placeDown()
	if not ok and msg ~= "No items to place" then
		ok, msg = selectNewItem()
		if not ok then
			return ok, msg
		end
	elseif not ok then
		return ok, msg
	end

	return true
end

while true do
	local ok, msg = placeDown()
	if not ok then
		printError(msg)
		return
	end

	ok, msg = turtle.forward()
	if not ok and msg == "Movement obstructed" then
		if turn == "right" then
			for _ = 1, 2, 1 do
				ok, msg = placeDown()
				if not ok and msg ~= "Cannot place block here" then
					printError(msg)
					return
				end
				ok, msg = turtle.turnRight()
				if not ok then
					printError(msg)
					return
				end
				ok, msg = turtle.forward()
				if not ok then
					printError(msg)
					return
				end
			end

			turn = "left"
		elseif turn == "left" then
			for _ = 1, 2, 1 do
				ok, msg = placeDown()
				if not ok and msg ~= "Cannot place block here" then
					printError(msg)
					return
				end
				ok, msg = turtle.turnLeft()
				if not ok then
					printError(msg)
					return
				end
				ok, msg = turtle.forward()
				if not ok then
					printError(msg)
					return
				end
			end
			turn = "right"
		else
			printError("Something went wrong")
			return
		end
	elseif not ok then
		turtle.up()
		printError(msg)
		return
	end
end
