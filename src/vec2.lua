Vec2 = class("Vec2")

function Vec2:init()
	self.dir = 0
	self.int = 0
end

function Vec2:rotate(dir, abs)
	self.dir = ((abs and 0 or self.dir)+dir)%math.rad(360)
end

function Vec2:setComponents(c1, c2)
	self.dir = math.atan2(c2, c1)
	self.int = math.sqrt(c1^2+c2^2)
end

function Vec2:getComponents()
	return
		math.cos(self.dir)*self.int,
		math.sin(self.dir)*self.int
end
