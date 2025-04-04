---@diagnostic disable:undefined-global
local fuel = require("fuel")
local args = { ... }

if #args ~= 1 then
	printError("Incorrect amount of arguments")
end

local turn = args[1]
if turn == nil then
	error("Arg was nill")
	return
else
	if turn ~= "left" and turn ~= "right" then
		error("Incorrect turn direction")
		return
	end
end

local item = turtle.getItemDetail(slot)
if item == nil then
	error("No Item selected")
	return
end

if fuel.shouldFuel() then
	local ok, msg = fuel.fuelUp()
	if not ok then
		error(msg)
	end
end

local function selectNewItem()
	for slot = 1, 16, 1 do
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

local function tryPlaceBlock()
	local ok, msg = turtle.placeDown()
	if not ok and msg == "No items to place" then
		ok, msg = selectNewItem()
		if not ok then
			return ok, msg
		end

		local ok, msg = turtle.placeDown()
		if not ok then
			return ok, msg
		end
	elseif not ok then
		return ok, msg
	end

	return true
end

while true do
	local ok, msg = tryPlaceBlock()
	if not ok then
		error(msg)
	end

	ok, msg = turtle.forward()
	if not ok and msg == "Movement obstructed" then
		if turn == "right" then
			for _ = 1, 2, 1 do
				ok, msg = tryPlaceBlock()
				if not ok and msg ~= "Cannot place block here" then
					error(msg)
				end
				ok, msg = turtle.turnRight()
				if not ok then
					error(msg)
				end
				ok, msg = turtle.forward()
				if not ok then
					error(msg)
				end
			end

			turn = "left"
		elseif turn == "left" then
			for _ = 1, 2, 1 do
				ok, msg = tryPlaceBlock()
				if not ok and msg ~= "Cannot place block here" then
					error(msg)
				end
				ok, msg = turtle.turnLeft()
				if not ok then
					error(msg)
				end
				ok, msg = turtle.forward()
				if not ok then
					error(msg)
				end
			end
			turn = "right"
		else
			error("Something went wrong")
		end
	elseif not ok then
		turtle.up()
		error(msg)
		return
	end
end
