Timer = class("Timer")

function Timer:init(duration, onFinish, reverse)
	self.duration = duration
	self.onFinish = onFinish
	self.reverse = reverse
	self.time = 0
end

function Timer:revert()
	self.reverse = not self.reverse
	self.time = 0
end

function Timer:update(dt, over_func)
	local exec = self.time < self.duration
	self.time = math.min(self.time+60*dt, self.duration)
	self.over = (self.time == self.duration)

	if exec and self.over then
		if over_func then over_func() end
		if self.onFinish then self:onFinish() end
	end
end

function Timer:getProgress()
	if self.duration == 0 then return 1 end
	local progress = self.time/self.duration
	return self.reverse and 1-progress or progress
end
