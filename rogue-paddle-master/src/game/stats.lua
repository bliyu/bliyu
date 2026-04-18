local Element = require 'ui.element'
local Fragment = require 'ui.fragment'

local HUD_PILL_HEIGHT = 11

local lives_hud = Element.new {
  style = {
    Res.styles.HUD_PANEL,
    gap = 2,
    width = '14vw',
    height = HUD_PILL_HEIGHT,
  },
  state = {
    name = 'Lives HUD',
  },
}

---@class Stats
local Stats = {
  score = Reactive.useCell(0),
  coins = Reactive.useCell(0),
  level = Reactive.useCell(1),
  msg = Reactive.useCell '',

  lives = Cell.new(0, function(v)
    local lives = lives_hud.get()
    lives:clearChildren()

    ---@type UiChildren
    local children = {}

    for _ = 1, v do
      children[#children + 1] = Res.sprites.HEART:ui {
        frame_idx = 1,
        color = Color.CORAL,
      }
    end

    lives:addChildren(children)
  end),
}

-- local info_text = Reactive.new { val = nil, font = Res.fonts.BASE }

-- Stats.msg = Builtin.accessor(nil, function(val)
--   info_text.val = val
-- end)

-- Stats.lives = Builtin.accessor(0, function(val)
-- end)
--
-- local info_ui = Element.new {
--   style = {
--     {
--       width = '100vw',
--       height = '100vh',
--       justify_content = 'center',
--       align_items = 'center',
--     },
--   },
--   Fragment.new(info_text),
-- }

local pause_icon = {
  frame_idx = 89,
  color = Color.RESET,
}

local function togglePauseOverlay()
  local ctx = S.getCtx()
  if not ctx or ctx.shop_locked then
    return
  end

  if ctx:hasOverlay() then
    ctx:popOverlay()
    pause_icon.frame_idx = 89
  else
    ctx:setOverlay(require 'game.overlays.pause')
    pause_icon.frame_idx = 72
  end
end

Stats.hud = Element.new {
  style = {
    width = '100vw',
    height = '100vh',
    flex_dir = 'col',
    gap = 0,
  },
  Element.new {
    style = {
      width = '100vw',
      height = '12vh',
      justify_content = 'end',
      align_items = 'center',
      gap = 2,
      extend = { 4, 4, 0, 4 },
    },
    lives_hud,
    Element.new {
      style = {
        Res.styles.HUD_PANEL,
        width = '11vw',
        height = HUD_PILL_HEIGHT,
        justify_content = 'center',
        gap = 2,
      },
      Fragment.new { val = 'Level', font = Res.fonts.HUD },
      Fragment.new { val = Stats.level, font = Res.fonts.HUD },
    },
    Element.new {
      style = {
        Res.styles.HUD_PANEL,
        width = '12vw',
        height = HUD_PILL_HEIGHT,
        justify_content = 'center',
        gap = 2,
      },
      Fragment.new { val = 'Coins', font = Res.fonts.HUD },
      Fragment.new { val = Stats.coins, font = Res.fonts.HUD },
    },
    Element.new {
      style = {
        Res.styles.BUTTON,
        width = '5vw',
        height = HUD_PILL_HEIGHT,
        justify_content = 'center',
        extend = { 2 },
      },
      Res.sprites.ICONS:ui(pause_icon),
      events = {
        onClick = togglePauseOverlay,
      },
      state = {
        name = 'Pause HUD',
      },
    },
  },
  Element.new {
    style = {
      width = '100vw',
      height = '34vh',
    },
  },
  Element.new {
    style = {
      width = '100vw',
      height = '10vh',
      justify_content = 'center',
      align_items = 'center',
    },
    Element.new {
      style = {
        Res.styles.HUD_PANEL,
        width = '32vw',
        justify_content = 'center',
        gap = 2,
        extend = { 3, 5 },
      },
      Fragment.new { val = Stats.msg, font = Res.fonts.HUD, max_width = '26vw', align = 'center' },
    },
  },
  state = {
    name = 'HUD Wrapper',
  },
}

Stats.togglePauseOverlay = togglePauseOverlay

return Stats
