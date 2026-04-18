local Progress = {
  high_score = Reactive.useCell(0),
  best_coins = Reactive.useCell(0),
  best_level = Reactive.useCell(1),
}

local SAVE_FILE = 'progress.sav'

local function parseValue(contents, key, fallback)
  local value = contents:match(key .. '=(%-?%d+)')
  return value and tonumber(value) or fallback
end

function Progress.load()
  if not love.filesystem.getInfo(SAVE_FILE) then
    return
  end

  local contents = love.filesystem.read(SAVE_FILE)
  if not contents then
    return
  end

  Progress.high_score.set(parseValue(contents, 'high_score', Progress.high_score.get()))
  Progress.best_coins.set(parseValue(contents, 'best_coins', Progress.best_coins.get()))
  Progress.best_level.set(parseValue(contents, 'best_level', Progress.best_level.get()))
end

function Progress.save()
  local payload = table.concat({
    'high_score=' .. Progress.high_score.get(),
    'best_coins=' .. Progress.best_coins.get(),
    'best_level=' .. Progress.best_level.get(),
  }, '\n')

  love.filesystem.write(SAVE_FILE, payload)
end

---@param score number
---@param coins number
---@param level number
function Progress.recordRun(score, coins, level)
  Progress.high_score.set(math.max(Progress.high_score.get(), score))
  Progress.best_coins.set(math.max(Progress.best_coins.get(), coins))
  Progress.best_level.set(math.max(Progress.best_level.get(), level))
  Progress.save()
end

return Progress
