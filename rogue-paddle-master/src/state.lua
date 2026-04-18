---@type fun()?
local next_scene = nil

local aspect_ratio = 16 / 10
local S = {
  ---@return (fun(): Scene)?
  queueScene = function()
    local init = next_scene
    next_scene = nil
    return init
  end,

  ---@param scene fun(): Scene
  setScene = function(scene)
    next_scene = scene
  end,

  --- getter is made when the scene is created
  ---@return Status?
  getCtx = function()
    return nil
  end,

  seed = 0,
  alpha = 0,
  -- mouse position
  cursor = Box.zero(),

  camera = {
    -- desired aspect ratio for the display
    aspect_ratio = aspect_ratio,
    -- the games viewport/camera
    shake = {
      time = 0,
      duration = 0,
      strength = 0,
      offset = Vec2.zero(),
    },
    box = Box.new(
      Vec2.zero(),
      -- how tall the virtual screen is in virtual units
      -- divide width by the aspect ratio so a 16:9 screen gets a height of 135
      -- (240/1.78) instead of 240, making it proportional
      Vec2.new(270, 270 / aspect_ratio)
    ),
  },
}

math.randomseed(S.seed)

return S
