OptionState = MenuState:extend("OptionState")

function OptionState:init()
	self.super.init(
		self, "Options", 
		{
		{
		label = "Fullscreen",
		value = FULLSCREEN,
		onKeyPress = function(self, key, item)
			if table.check(KEYS.confirm, key) then
				FULLSCREEN = not FULLSCREEN
				item.value = FULLSCREEN
				updateDisplay()
			end
		end,
		},
		{
		label = "Window Scale",
		value = WINDOW_SCALE,
		onKeyPress = function(self, key, item)
			local a =
				(table.check(KEYS.right, key) and 1 or 0)
				-(table.check(KEYS.left, key) and 1 or 0)
			if a ~= 0 then
				WINDOW_SCALE = WINDOW_SCALE+a
				item.value = WINDOW_SCALE
				updateDisplay()
			end
		end,
		},
		{
		label = "Back",
		onKeyPress = function(self, key)
			if table.check(KEYS.confirm, key) then
				self:onExit()
			end
		end,
		},
		}
	)
end

