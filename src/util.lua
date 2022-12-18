function clamp(a, min, max)
	return math.max(min, math.min(max, a))
end

function lerp(a, b, t)
	return a + (b - a) * t
end

function sign(a)
	return (a < 0) and -1 or 1
end

function floor(a)
	local dec = a-math.floor(a)
	local func = (dec >= .5) and math.ceil or math.floor
	return func(a)
end

function pixelToTile(x, y)
	return math.floor(x/TILESIZE), math.floor(y/TILESIZE)
end

function tileToPixel(x, y)
	return x*TILESIZE, y*TILESIZE
end

function formatPath(str)
	str = string.gsub(str, "%.%./", "")
	str = string.gsub(str, "/", ".")
	str = string.gsub(str, "%.lua", "")
	return str
end

function table.check(table, val)
	for i,v in ipairs(table) do
		if v == val then
			return i
		end
	end
end

function dirToVec(dir)
	local dirs = {
		{1, 0},
		{0, 1},
		{-1, 0},
		{0, -1},
	}
	return dirs[dir]
end
