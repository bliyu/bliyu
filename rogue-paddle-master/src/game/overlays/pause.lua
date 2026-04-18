local Element = require 'ui.element'
local Fragment = require 'ui.fragment'
local Presentation = require 'game.presentation'

return function()
  ---@type UiState
  local settings = Reactive.useState {
    hidden = true,
  }

  ---@type UiState
  local scores = Reactive.useState {
    hidden = true,
  }

  ---@type UiState
  local shop = Reactive.useState {
    hidden = true,
  }

  ---@type UiState
  local menu = Reactive.useState {
    hidden = false,
  }

  return Status.new {
    draw = function()
      Presentation.drawOverlayBackdrop()
    end,
    ui = Element.new {
      style = {
        width = '100vw',
        height = '100vh',
        flex_dir = 'col',
        align_items = 'center',
        justify_content = 'center',
      },
      Element.new {
        style = {
          Res.styles.OVERLAY,
          width = 96,
          gap = 3,
          extend = { 6, 7, 6, 7 },
          align_items = 'center',
          justify_content = 'center',
        },
        state = menu,
        Element.new {
          style = {
            width = 82,
            justify_content = 'center',
          },
          Fragment.new { val = 'PAUSED', font = Res.fonts.IBM, max_width = 72, align = 'center' },
        },
        Element.new {
          style = {
            width = 82,
            flex_dir = 'col',
            align_items = 'center',
            justify_content = 'center',
            gap = 2,
          },
          Element.new {
            style = {
              Res.styles.BUTTON_PRIMARY,
              width = 70,
              justify_content = 'center',
              extend = { 3, 4, 3, 4 },
            },
            events = {
              onClick = function()
                local ctx = S.getCtx()
                if ctx and ctx:hasOverlay() then
                  ctx:popOverlay()
                end
              end,
            },
            Fragment.new { val = 'Resume', font = Res.fonts.BASE, align = 'center' },
          },
          Element.new {
            style = {
              Res.styles.BUTTON,
              width = 70,
              justify_content = 'center',
              extend = { 3, 4, 3, 4 },
            },
            events = {
              onClick = function()
                S.setScene(require 'game.scenes.brickin')
              end,
            },
            Fragment.new { val = 'Restart', font = Res.fonts.BASE, align = 'center' },
          },
          Element.new {
            style = {
              Res.styles.BUTTON,
              width = 70,
              justify_content = 'center',
              extend = { 3, 4, 3, 4 },
            },
            events = {
              onClick = function()
                menu.hidden = true
                settings.hidden = false
                scores.hidden = true
                shop.hidden = true
              end,
            },
            Fragment.new { val = 'Settings', font = Res.fonts.BASE, align = 'center' },
          },
          Element.new {
            style = {
              Res.styles.BUTTON,
              width = 70,
              justify_content = 'center',
              extend = { 3, 4, 3, 4 },
            },
            events = {
              onClick = function()
                menu.hidden = true
                scores.hidden = false
                settings.hidden = true
                shop.hidden = true
              end,
            },
            Fragment.new { val = 'Scores', font = Res.fonts.BASE, align = 'center' },
          },
          Element.new {
            style = {
              Res.styles.BUTTON,
              width = 70,
              justify_content = 'center',
              extend = { 3, 4, 3, 4 },
            },
            events = {
              onClick = function()
                menu.hidden = true
                shop.hidden = false
                scores.hidden = true
                settings.hidden = true
              end,
            },
            Fragment.new { val = 'Shop', font = Res.fonts.BASE, align = 'center' },
          },
          Element.new {
            style = {
              Res.styles.BUTTON,
              width = 70,
              justify_content = 'center',
              extend = { 3, 4, 3, 4 },
            },
            events = {
              onClick = function()
                love.event.quit(0)
              end,
            },
            Fragment.new { val = 'Quit', font = Res.fonts.BASE, align = 'center' },
          },
        },
      },
      require 'game.overlays.settings'(settings, function()
        menu.hidden = false
        settings.hidden = true
        shop.hidden = true
      end),
      require 'game.overlays.scores'(scores, function()
        menu.hidden = false
        scores.hidden = true
        shop.hidden = true
      end),
      require 'game.overlays.shop_preview'(shop, function()
        menu.hidden = false
        shop.hidden = true
      end),
      state = {
        name = 'Pause Menu',
      },
    },
  }
end
