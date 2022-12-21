Map = class("Map")

function Map:init(path)
	local map = require(path)
	self.w, self.h = map.width, map.height
	self.tilesize = map.tilewidth
	self.layers = map.layers
	self.tileset = map.tilesets[1]

	-- generate images
	for z,layer in ipairs(self.layers) do
		if layer.type == "imagelayer" then
			local img_path = "res/"..string.gsub(layer.image, "%.%./", "")
			layer.image = love.graphics.newImage(img_path)
			layer.image:setWrap(
				(layer.repeatx and "repeat" or "clampzero"),
				(layer.repeaty and "repeat" or "clampzero")
			)
			layer.quad = 
				love.graphics.newQuad(
					0, 0,
					WIDTH, HEIGHT,
					layer.image:getDimensions()
				)
		end
	end

	-- generate tileset
	local img_path = string.gsub(self.tileset.image, "%.%./", "res/")
	self.tileset.image = love.graphics.newImage(img_path)
	self.tileset.quads = {}
	self.tileset.slices = {}
	for i=0,self.tileset.tilecount-1 do
		local x = i%self.tileset.columns
		local y = math.floor(i/self.tileset.columns)
		table.insert(self.tileset.quads,
			love.graphics.newQuad(
				x*self.tilesize, y*self.tilesize,
				self.tilesize, self.tilesize,
				self.tileset.imagewidth, self.tileset.imageheight
			)
		)
		local slices = {}
		for j=0,self.tilesize-1 do
			table.insert(slices,
				love.graphics.newQuad(
					x*self.tilesize+j, y*self.tilesize,
					1, self.tilesize,
					self.tileset.imagewidth, self.tileset.imageheight
				)
			)
		end
		table.insert(self.tileset.slices, slices)
	end
end

function Map:generateObj()
	local obj = {}
	local world = bump.newWorld(self.tilesize)
	for z,layer in ipairs(self.layers) do
		if layer.type == "tilelayer" then
			for x=0,self.w do
			for y=0,self.h do
				for i,gid in ipairs(self:getTilesAt(x, y)) do
					if gid ~= 0 then
						world:add(
							{},
							x*self.tilesize, y*self.tilesize,
							self.tilesize, self.tilesize
						)
					end
				end
			end
			end
		elseif layer.type == "objectgroup" then
			for _,o in ipairs(layer.objects) do
				local path = o.properties.path
				if path then
					path = string.gsub(o.properties.path, "%.%./", "")
					path = string.gsub(o.properties.path, "/", ".")
					path = string.gsub(o.properties.path, "%.lua", "")
					local new_o = require(path)(o.x, o.y)
					table.insert(obj, new_o)
					world:add(
						new_o,
						new_o.x, new_o.y,
						new_o.r*2, new_o.r*2
					)
				end
			end
		end
	end
	return obj, world
end

function Map:isInside(x, y)
	return x >= 0 and y >= 0 and x < self.w and y < self.h
end

function Map:getDimensions()
	return
		self.w*self.tilesize,
		self.h*self.tilesize
end

function Map:pixelToTile(x, y)
	return
		math.floor(x/self.tilesize),
		math.floor(y/self.tilesize)
end

function Map:tileToPixel(x, y)
	return
		x*self.tilesize,
		y*self.tilesize
end

function Map:getTilesAt(x, y)
	local i = y*self.w+x+1
	local tiles = {}
	for _,layer in ipairs(self.layers) do
		if layer.type == "tilelayer" then
			local gid = layer.data[i]
			table.insert(tiles, gid)
		end
	end
	return tiles
end

function Map:drawBackgrounds(dir)
	love.graphics.setColor(1, 1, 1)
	for i,layer in ipairs(self.layers) do
		if layer.type == "imagelayer" then
			local off = -dir*500/(#self.layers-(i-1))
			local x = off*layer.parallaxx
			local y = 0
			layer.quad:setViewport(-x, -y, WIDTH, HEIGHT)
			love.graphics.draw(
				layer.image, layer.quad,
				layer.offsetx, layer.offsety
			)
		end
	end
end

function Map:draw(x_off, y_off)
	for x=0,self.w do
	for y=0,self.h do
		for i,gid in ipairs(self:getTilesAt(x, y)) do
			if gid ~= 0 then
				local p_x, p_y = self:tileToPixel(x, y)
				love.graphics.draw(
					self.tileset.image, self.tileset.quads[gid],
					p_x-x_off, p_y-y_off
				)
			end
		end
	end
	end
end

