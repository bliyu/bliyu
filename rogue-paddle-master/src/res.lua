local cursors = {
  hand = love.mouse.getSystemCursor 'hand',
}

local Res = {
  cheats = BUILD == 'dev',
  cursors = cursors,

  sprites = {
    PLAYER = Sprite.new 'res/sprites/player.png',
    BALL = Sprite.new 'res/sprites/ball.png',
    HEART = Sprite.new 'res/sprites/heart.png',
    ICONS = Sprite.new('res/sprites/lucid/IconsShadow-16.png', 10, 10),
  },

  fonts = {
    BASE = love.graphics.newFont('res/fonts/Mx437_IBM_Conv.ttf', 8),
    IBM = love.graphics.newFont('res/fonts/Px437_IBM_BIOS-2y.ttf', 16),
    TITLE = love.graphics.newFont('res/fonts/Px437_IBM_BIOS-2y.ttf', 16),
    HUD = love.graphics.newFont('res/fonts/Mx437_IBM_Conv.ttf', 6),
    TOP = love.graphics.newFont('res/fonts/Mx437_IBM_Conv.ttf', 7),
  },

  keybinds = {
    MOVE_RIGHT = { 'd', 'right', 'l' },
    MOVE_LEFT = { 'a', 'left', 'h' },
    MOVE_UP = { 'w', 'k', 'up' },
    MOVE_DOWN = { 's', 'j', 'down' },
    CONFIRM = 'space',
    PAUSE = 'escape',
  },

  styles = {
    ---@type UiStyle
    OVERLAY = {
      background_color = Color.SURFACE,
      border_color = Color.CYAN,
      content_color = Color.FOREGROUND,
      border = 1,
      border_radius = 6,
      extend = { 10, 12 },
      flex_dir = 'col',
      align_items = 'start',
      justify_content = 'start',
      gap = 8,
    },

    ---@type UiStyle
    BUTTON = {
      background_color = Color.SURFACE_ALT,
      border_color = Color.MUTED,
      content_color = Color.FOREGROUND,
      border = 1,
      border_radius = 5,
      extend = { 5, 4 },
      content_color = Color.FOREGROUND,
      flex_dir = 'row',
      gap = 3,
      align_items = 'center',
      hover = {
        background_color = Color.SURFACE_SOFT,
        border_color = Color.CYAN,
        content_color = Color.BRIGHT7,
        cursor = cursors.hand,
      },
    },

    BUTTON_PRIMARY = {
      background_color = Color.CORAL,
      border_color = Color.GOLD,
      content_color = Color.BACKGROUND,
      border = 1,
      border_radius = 5,
      extend = { 6, 4 },
      flex_dir = 'row',
      gap = 3,
      align_items = 'center',
      hover = {
        background_color = Color.GOLD,
        border_color = Color.BRIGHT7,
        content_color = Color.BACKGROUND,
        cursor = cursors.hand,
      },
    },

    HUD_PANEL = {
      background_color = { Color.SURFACE[1], Color.SURFACE[2], Color.SURFACE[3], 0.84 },
      border_color = { Color.CYAN[1], Color.CYAN[2], Color.CYAN[3], 0.45 },
      content_color = Color.FOREGROUND,
      border = 1,
      border_radius = 5,
      extend = { 4, 3 },
      gap = 3,
      align_items = 'center',
    },
  },

  -- defines layouts for bricks
  layouts = {
    LEVEL_1 = {
      { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
      { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
      { 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0 },
      { 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0 },
      { 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0 },
      { 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0 },
      { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
      { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
      { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
      { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
      { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
      { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
      { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
      { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
      { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
    },
    LEVEL_2 = {
      { 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0 },
      { 0, 0, 0, 1, 1, 1, 1, 1, 1, 0, 0, 0 },
      { 0, 0, 1, 1, 0, 1, 1, 0, 1, 1, 0, 0 },
      { 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0 },
      { 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0 },
      { 0, 0, 1, 1, 0, 1, 1, 0, 1, 1, 0, 0 },
      { 0, 0, 0, 1, 1, 1, 1, 1, 1, 0, 0, 0 },
      { 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0 },
      { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
      { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
      { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
      { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
      { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
      { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
      { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
    },
    LEVEL_3 = {
      { 0, 0, 1, 1, 0, 0, 0, 0, 1, 1, 0, 0 },
      { 0, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 0 },
      { 1, 1, 0, 1, 1, 0, 0, 1, 1, 0, 1, 1 },
      { 1, 1, 0, 0, 1, 1, 1, 1, 0, 0, 1, 1 },
      { 0, 1, 1, 0, 1, 1, 1, 1, 0, 1, 1, 0 },
      { 0, 0, 1, 1, 1, 0, 0, 1, 1, 1, 0, 0 },
      { 0, 1, 1, 0, 1, 1, 1, 1, 0, 1, 1, 0 },
      { 1, 1, 0, 0, 1, 1, 1, 1, 0, 0, 1, 1 },
      { 1, 1, 0, 1, 1, 0, 0, 1, 1, 0, 1, 1 },
      { 0, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 0 },
      { 0, 0, 1, 1, 0, 0, 0, 0, 1, 1, 0, 0 },
      { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
      { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
      { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
      { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
    },
  },
}

for _, font in pairs(Res.fonts) do
  font:setFilter('nearest', 'nearest', 0)
end

return Res
