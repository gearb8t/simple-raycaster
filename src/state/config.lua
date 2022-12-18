ConfigState = MenuState:extend("ConfigState")

function ConfigState:init(previous_sel)
	self.super.init(
		self, "System",
		{
		{
		label = "Fullscreen",
		},
		{
		label = "Window Scale",
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
	self.previous_sel = previous_sel
end

function ConfigState:onExit()
	self.super.onExit(self)
	self.fade.onFinish =
		function()
			GameState:pop()
			GameState:push(PauseState())
			if self.previous_sel then
				local state = GameState:getState()
				state.selection = self.previous_sel
			end
		end
end

