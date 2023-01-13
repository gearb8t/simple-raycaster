Player = class("Player")

function Player:init(x, y)
	self.x = x or 0
	self.y = y or 0
	self.spd = Vec2()
	self.walk_spd = 10
	self.turn_spd = 5
	self.r = 16
	self.h = 40
	self.dir = 0
	self.bounce = {h = 1, a = 0}
end

function Player:handleInput(dt)
	-- turning
	local turn_spd = math.rad(self.turn_spd)*60*dt
	if self.tg_dir then
		local turn_spd = turn_spd*2
		if self.dir < self.tg_dir then
			self.dir = math.min(self.dir+turn_spd, self.tg_dir)
		elseif self.dir > self.tg_dir then
			self.dir = math.max(self.dir-turn_spd, self.tg_dir)
		else
			self.tg_dir = nil
		end
		self.spd.int = 0
		return
	else
		local turn =
			(love.keyboard.isDown(KEYS.turn_r) and 1 or 0)
			-(love.keyboard.isDown(KEYS.turn_l) and 1 or 0)
		if love.keyboard.wasPressed(KEYS.q_turn) then
			self.tg_dir = self.dir+math.pi
		else
			self.dir = self.dir+turn*turn_spd
		end
	end

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

	-- bounce
	local spd = math.rad(10*60*dt)
	if self.bounce.a == 0 and (move_x ~= 0 or move_y ~= 0) then
		self.bounce.a = math.pi
	else
		self.bounce.a = math.max(0, self.bounce.a-spd)
	end
	self.bounce.h = 1+math.sin(self.bounce.a)/4
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
