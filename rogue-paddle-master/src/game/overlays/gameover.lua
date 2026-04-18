local Element = require 'ui.element'
local Fragment = require 'ui.fragment'
local Stats = require 'game.stats'
local Progress = require 'game.progress'
local Presentation = require 'game.presentation'
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
          width = '42vw',
        },
        Fragment.new { val = 'RUN OVER', font = Res.fonts.TITLE, max_width = '38vw', align = 'center' },
        Element.new {
          style = {
            width = '40vw',
            gap = 3,
            justify_content = 'center',
          },
          Element.new {
            style = {
              Res.styles.HUD_PANEL,
              width = '16vw',
              justify_content = 'center',
              gap = 2,
            },
            Fragment.new { val = 'Run Score', font = Res.fonts.BASE },
            Fragment.new { val = Stats.score, font = Res.fonts.BASE },
          },
          Element.new {
            style = {
              Res.styles.HUD_PANEL,
              width = '16vw',
              justify_content = 'center',
              gap = 2,
            },
            Fragment.new { val = 'Best Score', font = Res.fonts.BASE },
            Fragment.new { val = Progress.high_score, font = Res.fonts.BASE },
          },
        },
        Element.new {
            style = {
              Res.styles.BUTTON_PRIMARY,
              width = '18vw',
              justify_content = 'center',
            },
          events = {
            onClick = function()
              S.setScene(require 'game.scenes.brickin')
            end,
          },
          Fragment.new { val = 'Restart', font = Res.fonts.BASE },
        },
        Element.new {
          style = {
            Res.styles.BUTTON,
            width = '14vw',
            justify_content = 'center',
          },
          events = {
            onClick = function()
              love.event.quit(0)
            end,
          },
          Fragment.new { val = 'Quit', font = Res.fonts.BASE },
        },
      },
      state = {
        name = 'Gameover Menu',
      },
    },
  }
end
