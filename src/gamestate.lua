GameState = {}

function GameState:init()
	self.states = {}
end
GameState:init()

function GameState:getState(n)
	n = n or 0
	return self.states[(n > 0 and 0 or #self.states)+n]
end

function GameState:push(state)
	table.insert(self.states, state)
end

function GameState:pop(n)
	for i=1,n or 1 do
		table.remove(self.states)
	end
end

function GameState:clear()
	self.states = {}
end

function GameState:update(dt)
	local state = self:getState()
	if state and state.update then
		state:update(dt)
	end
end

function GameState:getTopMenu()
	local top_menu
	for _,state in ipairs(self.states) do
		local is_menu = (state.super and state.super.name == "MenuState")
		if is_menu then
			top_menu = state
		end
	end
	return top_menu
end

function GameState:draw()
	local top_menu = self:getTopMenu()
	for _,state in ipairs(self.states) do
		local is_menu = (state.super and state.super.name == "MenuState")
		if state.draw then
			if not is_menu or state == top_menu then
				state:draw()
			end
		end
	end
end
