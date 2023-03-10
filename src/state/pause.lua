PauseState = MenuState:extend("PauseState")

function PauseState:init()
	self.super.init(
		self, "Pause",
		{
		{
		label = "Resume",
		onKeyPress = function(self, key)
			if table.check(KEYS.confirm, key) then
				self:onExit()
			end
		end,
		},
		{
		label = "Option",
		onKeyPress = function(self, key)
			if table.check(KEYS.confirm, key) then
				GameState:push(OptionState())
			end
		end,
		},
		{
		label = "Quit",
		onKeyPress = function(self, key)
			if table.check(KEYS.confirm, key) then
				GameState:push(FadeState(
					20, function()
						GameState:clear()
						GameState:push(TitleState())
					end
					)
				)
			end
		end,
		},
		}
	)
end
