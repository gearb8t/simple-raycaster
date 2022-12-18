FadeState = class("FadeState")

function FadeState:init(duration, onFinish, reverse)
	self.timer = Timer(duration or 10, onFinish, reverse)
end

function FadeState:update(dt)
	self.timer:update(dt, function() GameState:pop() end)

	if self.timer.over and not self.timer.reverse then
		GameState:push(FadeState(self.duration, nil, true))
	end
end

function FadeState:draw()
	local alpha = self.timer:getProgress()
	love.graphics.setColor(0, 0, 0, alpha)
	love.graphics.rectangle( "fill", 0, 0, WIDTH, HEIGHT)
end
