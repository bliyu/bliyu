local Element = require 'ui.element'
local Fragment = require 'ui.fragment'
local Audio = require 'audio'

---@param state UiState
---@param on_back fun()
return function(state, on_back)
  return Element.new {
    style = {
      Res.styles.OVERLAY,
      width = '34vw',
      gap = 4,
    },
    state = state,
    Fragment.new { val = 'SETTINGS', font = Res.fonts.IBM },
    Element.new {
      style = {
        Res.styles.BUTTON,
        width = '16vw',
        justify_content = 'center',
      },
      events = {
        onClick = function()
          Audio.toggle()
        end,
      },
      Fragment.new { val = Audio.settings_label, font = Res.fonts.BASE },
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
  }
end
