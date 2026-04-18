local Element = require 'ui.element'
local Fragment = require 'ui.fragment'
local Presentation = require 'game.presentation'

---@param build {
--- title: Cell<string>,
--- subtitle: Cell<string>,
--- coins: Cell<number>,
--- message: Cell<string>,
--- offer_1_label: Cell<string>,
--- offer_2_label: Cell<string>,
--- offer_3_label: Cell<string>,
--- on_buy_1: fun(),
--- on_buy_2: fun(),
--- on_buy_3: fun(),
--- on_continue: fun(),
---}
return function(build)
  return function()
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
            width = '56vw',
            gap = 5,
          },
          Fragment.new { val = build.title, font = Res.fonts.TITLE, max_width = '46vw', align = 'center' },
          Fragment.new { val = build.subtitle, font = Res.fonts.BASE, max_width = '46vw', align = 'center' },
          Element.new {
            style = {
              Res.styles.HUD_PANEL,
              width = '44vw',
              justify_content = 'center',
              gap = 3,
            },
            Fragment.new { val = 'Coins', font = Res.fonts.BASE },
            Fragment.new { val = build.coins, font = Res.fonts.BASE },
          },
          Element.new {
            style = {
              Res.styles.BUTTON,
              width = '44vw',
              justify_content = 'center',
            },
            events = {
              onClick = build.on_buy_1,
            },
            Fragment.new { val = build.offer_1_label, font = Res.fonts.BASE, max_width = '40vw', align = 'center' },
          },
          Element.new {
            style = {
              Res.styles.BUTTON,
              width = '44vw',
              justify_content = 'center',
            },
            events = {
              onClick = build.on_buy_2,
            },
            Fragment.new { val = build.offer_2_label, font = Res.fonts.BASE, max_width = '40vw', align = 'center' },
          },
          Element.new {
            style = {
              Res.styles.BUTTON,
              width = '44vw',
              justify_content = 'center',
            },
            events = {
              onClick = build.on_buy_3,
            },
            Fragment.new { val = build.offer_3_label, font = Res.fonts.BASE, max_width = '40vw', align = 'center' },
          },
          Element.new {
            style = {
              Res.styles.BUTTON_PRIMARY,
              width = '24vw',
              justify_content = 'center',
            },
            events = {
              onClick = build.on_continue,
            },
            Fragment.new { val = 'Start Next Wave', font = Res.fonts.BASE },
          },
          Element.new {
            style = {
              Res.styles.HUD_PANEL,
              width = '44vw',
              justify_content = 'center',
            },
            Fragment.new { val = build.message, font = Res.fonts.BASE, max_width = '40vw', align = 'center' },
          },
        },
        state = {
          name = 'Shop Menu',
        },
      },
    }
  end
end
