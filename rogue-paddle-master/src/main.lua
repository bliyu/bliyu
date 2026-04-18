local tlfres = require 'lib.tlfres'
local canvas, canvas_w, canvas_h

---@type table<love.KeyConstant, boolean>
local keys_pressed = {}
---@type table<love.KeyConstant, boolean>
local keys_released = {}

---@type table<number, boolean>
local mouse_pressed = {}
---@type table<number, boolean>
local mouse_released = {}

local t = 0.0
local FIXED_DT = 1. / 64.
local accumulator = 0.0
local current_time = love.timer.getTime()

---@type Scene?
local current_scene

function love.load()
  -- you will not be able to accces anything loaded here before love.load executes
  Res = require 'res'
  require('game.progress').load()
  love.resize()
end

---@param dt number
function love.update(dt)
  local x, y = love.mouse.getPosition()
  S.cursor.pos.x = x
  S.cursor.pos.y = y

  local shake = S.camera.shake
  if shake.time > 0 then
    shake.time = math.max(0, shake.time - dt)
    local alpha = shake.duration > 0 and (shake.time / shake.duration) or 0
    local strength = shake.strength * alpha
    shake.offset.x = love.math.random(-1000, 1000) / 1000 * strength
    shake.offset.y = love.math.random(-1000, 1000) / 1000 * strength
  else
    shake.offset.x = 0
    shake.offset.y = 0
  end

  -- https://gafferongames.com/post/fix_your_timestep/
  -- We have 'freed the physics'

  local new_time = love.timer.getTime()
  local frame_time = new_time - current_time

  if frame_time > 0.25 then
    frame_time = 0.25
  end

  current_time = new_time
  accumulator = accumulator + frame_time

  if current_scene then
    current_scene:update(dt)

    for i = #Timer.delayed, 1, -1 do
      local delay = Timer.delayed[i]
      delay.time = delay.time - dt
      if delay.time <= 0 then
        delay.func()
        table.remove(Timer.delayed, i)
      end
    end
  end

  while accumulator >= FIXED_DT do
    if current_scene then
      current_scene:fixed(FIXED_DT)
    end

    t = t + FIXED_DT
    accumulator = accumulator - FIXED_DT
  end

  S.alpha = accumulator / FIXED_DT

  local next_scene = S.queueScene()

  if next_scene then
    local scene = next_scene()

    if current_scene then
      Timer.delayed = {}
      current_scene:exit()
    end

    love.mouse.setCursor()

    S.getCtx = function()
      return scene.ctx
    end

    current_scene = scene
  end

  keys_pressed = {}
  keys_released = {}
  mouse_pressed = {}
  mouse_released = {}
end

function love.draw()
  love.graphics.setCanvas(canvas)
  love.graphics.push()

  love.graphics.scale(canvas_w / S.camera.box.w, canvas_h / S.camera.box.h)
  love.graphics.translate(S.camera.shake.offset.x, S.camera.shake.offset.y)
  love.graphics.translate(S.camera.box.x, S.camera.box.y)
  love.graphics.clear(Color.BACKGROUND)

  if current_scene then
    current_scene:draw()
  else
    --- loading.... ?
  end

  love.graphics.pop()
  love.graphics.setCanvas()

  tlfres.beginRendering(canvas_w, canvas_h)
  love.graphics.setColor(Color.RESET)
  love.graphics.draw(canvas)
  tlfres.endRendering()
end

function love.resize()
  local width, height = love.graphics.getDimensions()

  if width / height > S.camera.aspect_ratio then
    canvas_w = height * S.camera.aspect_ratio
    canvas_h = height
  else
    canvas_w = width
    canvas_h = width / S.camera.aspect_ratio
  end

  canvas = love.graphics.newCanvas(canvas_w, canvas_h)
end

-- keyboard

---@return boolean
function love.keyboard.isAnyPressed()
  return next(keys_pressed) ~= nil
end

---@return boolean
function love.keyboard.isAnyReleased()
  return next(keys_released) ~= nil
end

---@param key love.KeyConstant
---@param ... love.KeyConstant
---@return boolean
function love.keyboard.isPressed(key, ...)
  return Builtin.any(keys_pressed, key, ...) or false
end

---@param key love.KeyConstant
---@param ... love.KeyConstant
---@return boolean
function love.keyboard.isReleased(key, ...)
  return Builtin.any(keys_released, key, ...) or false
end

---@param key love.KeyConstant
function love.keypressed(key, _scancode, _isrepeat)
  keys_pressed[key] = true
end

---@param key love.KeyConstant
function love.keyreleased(key)
  keys_released[key] = true
end

-- mouse

---@diagnostic disable-next-line: duplicate-set-field
love.mouse.getPosition = function()
  return tlfres.getMousePosition(S.camera.box.w, S.camera.box.h)
end

---@param button number
function love.mousepressed(_, _, button)
  mouse_pressed[button] = true
end

---@param button number
function love.mousereleased(_, _, button)
  mouse_released[button] = true
end

---@param button number
---@return boolean
function love.mouse.isPressed(button)
  return mouse_pressed[button]
end

---@param button number
---@return boolean
function love.mouse.isReleased(button)
  return mouse_released[button]
end
