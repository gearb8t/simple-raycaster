pressed_keys = {}

function love.keyboard.lastPressed(...)
	local keys, min = {}, nil
	for i,key in ipairs({...}) do
		if type(key) == "table" then
			for j,key in ipairs(key) do
				local time = pressed_keys[key]
				if time then
					table.insert(keys, {i = i, time = time})
					if not min or time < min then
						min = time
					end
				end
			end
		elseif type(key) == "string" then
			local time = pressed_keys[key]
			if time then
				table.insert(keys, {i = i, time = time})
				if not min or time < min then
					min = time
				end
			end
		end
	end
	for i,v in ipairs(keys) do
		if min == v.time then
			return v.i
		end
	end
end

function love.keyboard.wasPressed(...)
	local check_keys = {...}
	for key,time in pairs(pressed_keys) do
		for i,check_key in ipairs(check_keys) do
			if type(check_key) == "table" then
				for i,check_key in ipairs(check_key) do
					if check_key == key and time == 0 then
						return true
					end
				end
			elseif type(check_key) == "string" then
				if check_key == key and time == 0 then
					return true
				end
			end
		end
	end
end

function love.keypressed(key)
	love.keyboard.setKeyRepeat(
		key == "right" or
		key == "left" or
		key == "up" or
		key == "down"
	)
	pressed_keys[key] = 0
end
