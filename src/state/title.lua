TitleState = MenuState:extend("TitleState")

function TitleState:init()
	self.super.init(
		self, nil,
		{
		{
		label = "New Game",
		onKeyPress = function(self, key)
			if table.check(KEYS.confirm, key) then
				GameState:push(FadeState(
					20, function()
						GameState:clear()
						GameState:push(PlayState("res.map.test"))
					end
					)
				)
			end
		end,
		},
		{
		label = "Continue",
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
				GameState:push(FadeState(25, love.event.quit))
			end
		end,
		}
		}
	)
end

function TitleState:onExit() end
