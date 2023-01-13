castRay = function(x, y, dir, map)
	local h, v = {}, {}

	-- horizontal intersection
	local up = math.sin(dir) < 0
	_, h.start_y = map:pixelToTile(x, y)
	h.start_y = h.start_y*map.tilesize+(up and -1e-5 or map.tilesize)
	h.start_x = x-(y-h.start_y)/math.tan(dir)
	h.step_y = map.tilesize*(up and -1 or 1)
	h.step_x = map.tilesize/math.tan(dir)*(up and -1 or 1)
	h.tile_x, h.tile_y = h.start_x, h.start_y
	h.tiles = map:getTilesAt(map:pixelToTile(h.tile_x, h.tile_y))
	while h.tiles[1] == 0 do
		h.tile_x, h.tile_y = h.tile_x+h.step_x, h.tile_y+h.step_y
		h.tiles = map:getTilesAt(map:pixelToTile(h.tile_x, h.tile_y))
		if not map:isInside(map:pixelToTile(h.tile_x, h.tile_y)) then
			h.tiles = {0}
			break
		end
	end
	h.depth = math.sqrt((x-h.tile_x)^2+(y-h.tile_y)^2)
	h.txt_off = math.floor((h.tile_x)%map.tilesize)+1

	-- vertival intersection
	local left = math.cos(dir) < 0
	v.start_x = map:pixelToTile(x, y)
	v.start_x = v.start_x*map.tilesize+(left and -1e-5 or map.tilesize)
	v.start_y = y-(x-v.start_x)*math.tan(dir)
	v.step_x = map.tilesize*(left and -1 or 1)
	v.step_y = map.tilesize*math.tan(dir)*(left and -1 or 1)
	v.tile_x, v.tile_y = v.start_x, v.start_y
	v.tiles = map:getTilesAt(map:pixelToTile(v.tile_x, v.tile_y))
	while v.tiles[1] == 0 do
		v.tile_x, v.tile_y = v.tile_x+v.step_x, v.tile_y+v.step_y
		v.tiles = map:getTilesAt(map:pixelToTile(v.tile_x, v.tile_y))
		if not map:isInside(map:pixelToTile(v.tile_x, v.tile_y)) then
			v.tiles = {0}
			break
		end
	end
	v.depth = math.sqrt((x-v.tile_x)^2+(y-v.tile_y)^2)
	v.txt_off = math.floor((v.tile_y)%map.tilesize)+1

	local min = (v.depth < h.depth) and v or h
	return
		min.depth,                              -- depth
		min.tiles,                              -- hit tiles
		(min == h and 1 or .750),               -- shade
		min.txt_off,                            -- texture offset
		map:pixelToTile(min.tile_x, min.tile_y) -- tile_x, tile_y
end
