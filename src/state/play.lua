PlayState = class("PlayState")

function PlayState:init(map_path)
	self.map = Map(map_path)
	self.obj, self.world = self.map:generateObj()
end

function PlayState:getObj(name)
	for _,obj in ipairs(self.obj) do
		if obj.name == name then
			return obj
		end
	end
end

function PlayState:update(dt)
	for _,obj in ipairs(self.obj) do
		if obj.update then
			obj:update(dt)
		end

		-- physics
		local x_spd, y_spd = obj.spd:getComponents()
		local a_x, a_y, cols = self.world:move(
			obj,
			obj.x-obj.r+x_spd*60*dt,
			obj.y-obj.r+y_spd*60*dt
		)
		for i,col in ipairs(cols) do
			if col.normal.x ~= 0 then
				x_spd = 0
			end
			if col.normal.y ~= 0 then
				y_spd = 0
			end
		end
		obj.spd:setComponents(x_spd, y_spd)
		obj.x, obj.y = a_x+obj.r, a_y+obj.r
	end

	-- input
	if love.keyboard.wasPressed(KEYS.pause) then
		GameState:push(PauseState())
	end
end

function PlayState:draw()
	self:drawFirstPerson()
end

function PlayState:drawTopDown()
	local player = self:getObj("Player")
	local cam_x, cam_y = 0, 0
	if player then
		local map_w, map_h = self.map:getDimensions()
		cam_x = clamp(player.x-WIDTH/2, 0, map_w-WIDTH)
		cam_y = clamp(player.y-HEIGHT/2, 0, map_h-HEIGHT)
	end

	self.map:draw(cam_x, cam_y)

	for _,obj in ipairs(self.obj) do
		if obj.draw then
			obj:draw(cam_x, cam_y)
		end
	end
end

function PlayState:drawFirstPerson()
	local player = self:getObj("Player")
	if not player then return false end
	local FOV = math.rad(FOV)
	local ground_y = HEIGHT/2
	local proj_depth = (WIDTH/2)/math.tan(FOV/2)
	local player_h = player.h*player.bounce.h

	-- background
	self.map:drawBackgrounds(player.dir)

	-- ground
	love.graphics.setColor(.6, .3, .1)
	love.graphics.rectangle(
		"fill",
		0, ground_y,
		WIDTH, ground_y
	)

	-- walls
	for x=1,WIDTH do
		local dir = player.dir-FOV/2+(FOV/WIDTH)*x
		local depth, tiles, shade, txt_off = castRay(
			player.x,
			player.y,
			dir,
			self.map
		)
		local depth = depth*math.cos(dir-player.dir)
		local wall_h = self.map.tilesize/depth*proj_depth
		local ratio = proj_depth/depth
		local shade = lerp(shade, 0, depth/2000)
		love.graphics.setColor(shade, shade, shade)
		for z,t_id in ipairs(tiles) do
			if t_id ~= 0 then
				love.graphics.draw(
					self.map.tileset.image,
					self.map.tileset.slices[t_id][txt_off],
					x-1, ground_y-wall_h*z+ratio*player_h,
					0,
					1, wall_h/self.map.tilesize
				)
			end
		end
	end
end
