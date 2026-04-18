local Element = require 'ui.element'
local Fragment = require 'ui.fragment'
local Stats = require 'game.stats'
local Progress = require 'game.progress'

---@param state UiState
---@param on_back fun()
return function(state, on_back)
  return Element.new {
    style = {
      Res.styles.OVERLAY,
      width = '40vw',
      gap = 4,
    },
    state = state,
    Fragment.new { val = 'SCORES', font = Res.fonts.IBM },
    Element.new {
      style = {
        flex_dir = 'col',
        align_items = 'start',
        gap = 3,
      },
      Element.new {
        style = {
          Res.styles.HUD_PANEL,
          width = '30vw',
          gap = 3,
          justify_content = 'center',
        },
        Fragment.new { val = 'High Score', font = Res.fonts.BASE },
        Fragment.new { val = Progress.high_score, font = Res.fonts.BASE },
      },
      Element.new {
        style = {
          Res.styles.HUD_PANEL,
          width = '30vw',
          gap = 3,
          justify_content = 'center',
        },
        Fragment.new { val = 'Best Coins', font = Res.fonts.BASE },
        Fragment.new { val = Progress.best_coins, font = Res.fonts.BASE },
      },
      Element.new {
        style = {
          Res.styles.HUD_PANEL,
          width = '30vw',
          gap = 3,
          justify_content = 'center',
        },
        Fragment.new { val = 'Best Level', font = Res.fonts.BASE },
        Fragment.new { val = Progress.best_level, font = Res.fonts.BASE },
      },
      Element.new {
        style = {
          Res.styles.HUD_PANEL,
          width = '30vw',
          gap = 3,
          justify_content = 'center',
        },
        Fragment.new { val = 'Run Score', font = Res.fonts.BASE },
        Fragment.new { val = Stats.score, font = Res.fonts.BASE },
      },
      Element.new {
        style = {
          Res.styles.BUTTON,
          width = '16vw',
          justify_content = 'center',
        },
        events = {
          onClick = on_back,
        },
        Fragment.new { val = 'Back', font = Res.fonts.BASE },
      },
    },
  }
end
