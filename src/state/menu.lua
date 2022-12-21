MenuState = class("MenuState")

function MenuState:init(title, items)
	self.title = title or ""
	self.items = items or {}
	self.selection = 1
	self.font = love.graphics.newFont("res/font/terminus.ttf", 20)
	self.font_bold = love.graphics.newFont("res/font/terminus-bold.ttf", 20)
end

function MenuState:onExit()
	GameState:pop()
end

function MenuState:moveSelection(a, loop)
	self.selection = self.selection+a
	if (loop or true) then
		if self.selection < 1 then
			self.selection = #self.items
		elseif self.selection > #self.items then
			self.selection = 1
		end
	else
		self.selection = clamp(self.selection, 1, #self.items)
	end
end

function MenuState:update(dt)
	-- input
	local move = 
		(love.keyboard.wasPressed(KEYS.down) and 1 or 0)
		-(love.keyboard.wasPressed(KEYS.up) and 1 or 0)
	if move ~= 0 then
		self:moveSelection(move)
	end
	for key,time in pairs(pressed_keys) do
		if time == 0 then
			if table.check(KEYS.pause, key) or
			   table.check(KEYS.cancel, key) then
				self:onExit()
			elseif self.items[self.selection] then
				local item = self.items[self.selection]
				if item.onKeyPress then
					item.onKeyPress(self, key, item)
				end
			end
		end
	end
end

function MenuState:getMaxLen()
	local max_len, max
	for i,item in ipairs(self.items) do
		local len = string.len(self:getItemText(i, true))
		if not max or len > max_len then
			max_len = len
			max = i
		end
	end
	return max_len, max
end

function MenuState:getItemText(i, ignore_value)
	local item = self.items[i]
	local text = item.label
	if not ignore_value and item.value ~= nil then
		local max_len = self:getMaxLen()
		local padding = 1+max_len-string.len(item.label)
		local text = text..string.rep(" ", padding)
		if type(item.value) == "boolean" then
			return text..(item.value and "ON" or "OFF")
		else
			return text..item.value
		end
	else
		return text
	end
end

function MenuState:drawBackground()
	love.graphics.setColor(0, 0, 0, .5)
	love.graphics.rectangle( "fill", 0, 0, WIDTH, HEIGHT)
end

function MenuState:drawTitle()
	love.graphics.setColor(1, 1, 1)
	love.graphics.printf(
		self.title, self.font_bold,
		10, 1,
		WIDTH, "left",
		0,
		1, 1,
		0, 0,
		-.25, 0
	)
end

function MenuState:drawItems()
	local font_h = self.font:getHeight()
	local sel_char = "▶"
	local max_len, max = self:getMaxLen()
	local max_w = self.font:getWidth(self:getItemText(max))
	local x = (WIDTH-max_w)/2
	local y = (HEIGHT-font_h*#self.items)/2
	love.graphics.setColor(1, 1, 1)
	for i,item in ipairs(self.items) do
		if item.label then
			local y = y+font_h*(i-1)
			love.graphics.printf(
				self:getItemText(i), self.font,
				x, y,
				WIDTH, "left"
			)
		end
	end
	love.graphics.printf(
		sel_char, self.font,
		x-self.font:getWidth(' '),
		y+font_h*(self.selection-1),
		WIDTH, "left"
	)
end

function MenuState:draw()
	self:drawBackground()
	self:drawTitle()
	self:drawItems()
end
