local SAMPLE_RATE = 44100

local Audio = {
  volume = Cell.new(1.0),
  label = Cell.new 'On',
  settings_label = Cell.new 'Audio: On',
  _sources = nil,
}

---@param frequency number
---@param duration number
---@param opts? { wave?: "'sine'"|"'square'"|"'triangle'", attack?: number, release?: number, gain?: number }
---@return love.Source
local function makeTone(frequency, duration, opts)
  opts = opts or {}

  local samples = math.max(1, math.floor(SAMPLE_RATE * duration))
  local sound_data = love.sound.newSoundData(samples, SAMPLE_RATE, 16, 1)
  local attack = opts.attack or 0.01
  local release = opts.release or 0.04
  local gain = opts.gain or 0.25
  local wave = opts.wave or 'sine'

  for i = 0, samples - 1 do
    local t = i / SAMPLE_RATE
    local phase = 2 * math.pi * frequency * t
    local sample

    if wave == 'square' then
      sample = math.sin(phase) >= 0 and 1 or -1
    elseif wave == 'triangle' then
      sample = (2 / math.pi) * math.asin(math.sin(phase))
    else
      sample = math.sin(phase)
    end

    local env = 1
    if t < attack then
      env = t / attack
    elseif t > duration - release then
      env = math.max(0, (duration - t) / release)
    end

    sound_data:setSample(i, sample * env * gain)
  end

  return love.audio.newSource(sound_data, 'static')
end

function Audio.init()
  if Audio._sources then
    return
  end

  Audio._sources = {
    launch = makeTone(740, 0.07, { wave = 'square', gain = 0.18, release = 0.03 }),
    wall = makeTone(420, 0.05, { wave = 'square', gain = 0.14, release = 0.02 }),
    paddle = makeTone(520, 0.06, { wave = 'triangle', gain = 0.18, release = 0.03 }),
    brick = makeTone(660, 0.08, { wave = 'square', gain = 0.2, release = 0.03 }),
    lose_life = makeTone(220, 0.24, { wave = 'triangle', gain = 0.22, release = 0.08 }),
    game_over = makeTone(160, 0.4, { wave = 'triangle', gain = 0.24, release = 0.16 }),
  }

  Audio.setVolume(Audio.volume.get())
end

---@param volume number
function Audio.setVolume(volume)
  local next_volume = math.clamp(volume, 0, 1)
  Audio.volume.set(next_volume)
  Audio.label.set(next_volume > 0 and 'On' or 'Off')
  Audio.settings_label.set('Audio: ' .. Audio.label.get())
  love.audio.setVolume(next_volume)
end

function Audio.toggle()
  if Audio.volume.get() > 0 then
    Audio.setVolume(0)
  else
    Audio.setVolume(1)
  end
end

---@param name string
function Audio.play(name)
  Audio.init()

  local source = Audio._sources[name]
  if not source or Audio.volume.get() <= 0 then
    return
  end

  local instance = source:clone()
  instance:play()
end

return Audio
