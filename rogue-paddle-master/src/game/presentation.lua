local Presentation = {}

local function mix(a, b, t)
  return math.lerp(a, b, t)
end

local function mixColor(from, to, t, alpha)
  return {
    mix(from[1], to[1], t),
    mix(from[2], to[2], t),
    mix(from[3], to[3], t),
    alpha or mix(from[4] or 1, to[4] or 1, t),
  }
end

function Presentation.drawOverlayBackdrop()
  local w, h = S.camera.box.w, S.camera.box.h
  local pulse = 0.5 + math.sin(love.timer.getTime() * 2.1) * 0.5

  love.graphics.setColor(Color.SCRIM)
  love.graphics.rectangle('fill', 0, 0, w, h)

  love.graphics.setColor(0.07, 0.13, 0.18, 0.35 + pulse * 0.05)
  love.graphics.rectangle('fill', 0, 0, w, h * 0.32)

  love.graphics.setColor(Color.CYAN[1], Color.CYAN[2], Color.CYAN[3], 0.08 + pulse * 0.04)
  love.graphics.rectangle('fill', w * 0.06, h * 0.1, w * 0.88, h * 0.02)

  love.graphics.setColor(Color.GOLD[1], Color.GOLD[2], Color.GOLD[3], 0.04)
  love.graphics.rectangle('fill', w * 0.1, h * 0.86, w * 0.8, h * 0.015)
end

function Presentation.drawPlayfield(level, round)
  local w, h = S.camera.box.w, S.camera.box.h
  local t = love.timer.getTime()
  local drift = (t * 10) % 18
  local level_tint = ({ Color.CORAL, Color.GOLD, Color.CYAN })[math.min(level, 3)] or Color.CYAN

  for i = 0, 10 do
    local y = i * (h / 10)
    local shade = i / 10
    local c = mixColor(Color.BACKGROUND, Color.SURFACE_ALT, shade * 0.7, 1)
    love.graphics.setColor(c)
    love.graphics.rectangle('fill', 0, y, w, h / 10 + 1)
  end

  for i = -1, 16 do
    local x = i * 18 + drift
    love.graphics.setColor(Color.MUTED[1], Color.MUTED[2], Color.MUTED[3], 0.08)
    love.graphics.line(x, 0, x - 16, h)
  end

  for i = 0, 7 do
    local y = 20 + i * 16
    love.graphics.setColor(level_tint[1], level_tint[2], level_tint[3], 0.08)
    love.graphics.rectangle('fill', 18, y, w - 36, 1)
  end

  love.graphics.setColor(level_tint[1], level_tint[2], level_tint[3], 0.12)
  love.graphics.rectangle('fill', 14, 14, w - 28, 5, 2, 2)
  love.graphics.rectangle('fill', 14, h - 19, w - 28, 5, 2, 2)

  love.graphics.setColor(Color.SHADOW)
  love.graphics.rectangle('fill', 8, 8, w - 16, h - 16, 7, 7)
  love.graphics.setColor(Color.SURFACE[1], Color.SURFACE[2], Color.SURFACE[3], 0.22)
  love.graphics.rectangle('line', 10, 10, w - 20, h - 20, 7, 7)

  local title = string.format('ROUND %d', round)
  love.graphics.setFont(Res.fonts.BASE)
  love.graphics.setColor(level_tint[1], level_tint[2], level_tint[3], 0.16)
  love.graphics.printf(title, 0, h * 0.42, w, 'center')

  for i = 1, 18 do
    local px = (i * 41 + math.sin(t * 0.4 + i) * 24) % w
    local py = (i * 23 + math.cos(t * 0.35 + i * 0.7) * 12) % (h * 0.42)
    local a = 0.15 + ((math.sin(t * 1.7 + i * 1.9) + 1) * 0.5) * 0.2
    love.graphics.setColor(Color.FOREGROUND[1], Color.FOREGROUND[2], Color.FOREGROUND[3], a)
    love.graphics.rectangle('fill', px, py, 1, 1)
  end
end

return Presentation
