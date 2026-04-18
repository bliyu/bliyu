local Element = require 'ui.element'
local Fragment = require 'ui.fragment'
local Presentation = require 'game.presentation'

---@param build { on_start: fun() }
return function(build)
  ---@type UiState
  local menu = Reactive.useState {
    hidden = false,
  }

  ---@type UiState
  local help = Reactive.useState {
    hidden = true,
  }

  return Status.new {
    draw = function()
      Presentation.drawOverlayBackdrop()
    end,
    ui = Element.new {
      style = {
        width = '100vw',
        height = '100vh',
        align_items = 'center',
        justify_content = 'center',
      },
      Element.new {
        style = {
          Res.styles.OVERLAY,
          width = '46vw',
          gap = 4,
        },
        state = menu,
        Fragment.new { val = 'ROGUE PADDLE', font = Res.fonts.TITLE, max_width = '38vw', align = 'center' },
        Element.new {
          style = {
            width = '38vw',
            gap = 2,
            justify_content = 'center',
          },
          Element.new {
            style = {
              Res.styles.BUTTON_PRIMARY,
              width = '18vw',
              justify_content = 'center',
            },
            events = {
              onClick = build.on_start,
            },
            Fragment.new { val = 'Start', font = Res.fonts.BASE },
          },
          Element.new {
            style = {
              Res.styles.BUTTON,
              width = '12vw',
              justify_content = 'center',
            },
            events = {
              onClick = function()
                menu.hidden = true
                help.hidden = false
              end,
            },
            Fragment.new { val = 'Help', font = Res.fonts.BASE },
          },
        },
      },
      Element.new {
        style = {
          Res.styles.OVERLAY,
          width = '38vw',
          gap = 4,
        },
        state = help,
        Fragment.new { val = 'HELP', font = Res.fonts.TITLE, max_width = '30vw', align = 'center' },
        Element.new {
          style = {
            Res.styles.HUD_PANEL,
            width = '30vw',
            flex_dir = 'col',
            gap = 2,
            align_items = 'center',
          },
          Fragment.new { val = 'ARROWS  MOVE', font = Res.fonts.BASE, max_width = '26vw', align = 'center' },
          Fragment.new { val = 'SPACE  LAUNCH', font = Res.fonts.BASE, max_width = '26vw', align = 'center' },
        },
        Element.new {
          style = {
            Res.styles.BUTTON,
            width = '12vw',
            justify_content = 'center',
          },
          events = {
            onClick = function()
              help.hidden = true
              menu.hidden = false
            end,
          },
          Fragment.new { val = 'Back', font = Res.fonts.BASE },
        },
      },
      state = {
        name = 'Title Overlay',
      },
    },
  }
end
