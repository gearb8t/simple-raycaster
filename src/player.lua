Player = class("Player")

function Player:init(x, y)
	self.x, self.y = x or 0, y or 0
	self.spd = Vec2()
	self.walk_spd, self.turn_spd = 10, 5
	self.r, self.h = 10, 40
	self.bounce = 0
	self.dir = 0
end

function Player:handleInput(dt)
	-- movement
	local move_x =
		(love.keyboard.isDown(KEYS.strafe_r) and 1 or 0)
		-(love.keyboard.isDown(KEYS.strafe_l) and 1 or 0)
	local move_y =
		(love.keyboard.isDown(KEYS.down) and 1 or 0)
		-(love.keyboard.isDown(KEYS.up) and 1 or 0)
	if move_x ~= 0 or move_y ~= 0 then
		local move_dir = math.atan2(move_y, move_x)
		self.spd.dir = move_dir+self.dir+math.pi/2
		self.spd.int = self.walk_spd
	else
		self.spd.int = 0
	end

	-- turning
	local turn =
		(love.keyboard.isDown(KEYS.turn_r) and 1 or 0)
		-(love.keyboard.isDown(KEYS.turn_l) and 1 or 0)
	self.dir = self.dir+turn*math.rad(self.turn_spd)*60*dt

	-- bounce
	local moving = (move_x ~= 0 or move_y ~= 0 or turn ~= 0)
	if self.bounce == 0 and moving then
		self.bounce = math.pi
	else
		local spd = 20
		self.bounce = math.max(0, self.bounce-math.rad(spd*60*dt))
	end
end

function Player:update(dt)
	local state = GameState:getState()
	local map = state.map
	self.t_x, self.t_y = map:pixelToTile(self.x, self.y)

	self:handleInput(dt)
end

function Player:draw(x_off, y_off)
	love.graphics.setColor(1, 1, 0)
	love.graphics.circle(
		"fill",
		self.x-x_off,
		self.y-y_off,
		self.r
	)
	love.graphics.setColor(1, 0, 0)
	love.graphics.line(
		self.x-x_off,
		self.y-y_off,
		self.x-x_off+math.cos(self.dir)*self.r,
		self.y-y_off+math.sin(self.dir)*self.r
	)
end

return Player
