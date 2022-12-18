require "src.init"

-- globals
WIDTH  = 256
HEIGHT = 192
WINDOW_SCALE = 3
FULLSCREEN = false
FOV = 60
DEBUG = false

KEYS = {
	left    = {"a"},
	right   = {"d"},
	up      = {"w", "up"},
	down    = {"s", "down"},
	turn_l  = {"left"},
	turn_r  = {"right"},
	confirm = {"z", "return"},
	cancel  = {"x", "escape"},
	pause   = {"escape", "return"},
}

-- display
--love.graphics.setDefaultFilter("nearest", "nearest")
--love.graphics.setLineStyle("rough")
love.window.setMode(WIDTH*WINDOW_SCALE, HEIGHT*WINDOW_SCALE, {})
love.mouse.setVisible(false)
local canvas = love.graphics.newCanvas(WIDTH, HEIGHT)

function love.load()
	GameState:push(PlayState("res.map.test"))
	GameState:push(FadeState(30, nil, true))
end

function love.update(dt)
	GameState:update(dt)

	-- clear input
	for key,time in pairs(pressed_keys) do
		pressed_keys[key] = love.keyboard.isDown(key) and time+1 or nil
	end
end

function love.draw()
	love.graphics.setCanvas(canvas)
	love.graphics.clear()

	GameState:draw()

	love.graphics.setCanvas()
	love.graphics.setColor(1, 1, 1)
	love.graphics.draw(canvas, 0, 0, 0, WINDOW_SCALE, WINDOW_SCALE)
end
