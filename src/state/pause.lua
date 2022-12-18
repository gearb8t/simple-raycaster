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
		label = "System",
		onKeyPress = function(self, key)
			if table.check(KEYS.confirm, key) then
				self:onExit()
				self.fade.onFinish =
					function()
						GameState:pop()
						GameState:push(ConfigState(self.selection))
					end
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
		},
		}
	)
end
