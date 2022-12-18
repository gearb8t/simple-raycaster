MenuState = class("MenuState")

function MenuState:init(title, items)
	self.title = title or ""
	self.items = items or {}
	self.selection = 1
	self.fade = Timer(10)
	self.font = love.graphics.newFont("res/font/terminus.ttf", 20)
	self.font_bold = love.graphics.newFont("res/font/terminus-bold.ttf", 20)
end

function MenuState:onExit()
	self.fade:revert()
	self.fade.onFinish =
		function()
			GameState:pop()
		end
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
	self.fade:update(dt)
	if not self.fade.over then return end

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
				local onKeyPress =self.items[self.selection].onKeyPress
				if onKeyPress then
					onKeyPress(self, key)
				end
			end
		end
	end
end

function MenuState:getLargestItem()
	local max_len, max
	for i,item in ipairs(self.items) do
		if item.label then
			local len = string.len(item.label)
			if not max or len > max_len then
				max = i
				max_len = len
			end
		end
	end
	return max_len, max
end

function MenuState:draw()
	local alpha = self.fade:getProgress()

	-- background
	love.graphics.setColor(0, 0, 0, alpha*.5)
	love.graphics.rectangle( "fill", 0, 0, WIDTH, HEIGHT)

	-- title
	love.graphics.setColor(1, 1, 1, alpha+.5)
	love.graphics.printf(
		self.title, self.font_bold,
		5, 1,
		WIDTH, "left",
		0,
		.8, .8,
		0, 0,
		-.2, 0
	)

	-- text
	local font_h = self.font:getHeight()
	for i,item in ipairs(self.items) do
		if item.label then
			local max_len, max = self:getLargestItem()
			local x = (WIDTH-self.font:getWidth(self.items[max].label))/2
			local y = (HEIGHT-font_h*#self.items)/2+font_h*(i-1)
			local sel = (self.selection == i) and "▶" or " "
			love.graphics.setColor(1, 1, 1, alpha)
			love.graphics.printf(
				sel..item.label, self.font,
				x, y,
				WIDTH, "left"
			)
		end
	end
end
