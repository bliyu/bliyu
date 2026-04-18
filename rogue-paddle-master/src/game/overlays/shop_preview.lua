local Element = require 'ui.element'
local Fragment = require 'ui.fragment'
local ShopState = require 'game.shop_state'

---@param state UiState
---@param on_back fun()
return function(state, on_back)
  return Element.new {
    style = {
      Res.styles.OVERLAY,
      width = '42vw',
      gap = 4,
    },
    state = state,
    Fragment.new { val = ShopState.title, font = Res.fonts.IBM },
    Fragment.new { val = ShopState.subtitle, font = Res.fonts.BASE },
    Element.new {
      style = {
        Res.styles.HUD_PANEL,
        width = '32vw',
        gap = 3,
        justify_content = 'center',
      },
      Fragment.new { val = '$', font = Res.fonts.BASE },
      Fragment.new { val = ShopState.coins, font = Res.fonts.BASE },
    },
    Element.new {
      style = {
        flex_dir = 'col',
        align_items = 'start',
        gap = 3,
      },
      Element.new {
        style = {
          Res.styles.HUD_PANEL,
          width = '32vw',
        },
        Fragment.new { val = ShopState.offer_1, font = Res.fonts.BASE, max_width = '30vw' },
      },
      Element.new {
        style = {
          Res.styles.HUD_PANEL,
          width = '32vw',
        },
        Fragment.new { val = ShopState.offer_2, font = Res.fonts.BASE, max_width = '30vw' },
      },
      Element.new {
        style = {
          Res.styles.HUD_PANEL,
          width = '32vw',
        },
        Fragment.new { val = ShopState.offer_3, font = Res.fonts.BASE, max_width = '30vw' },
      },
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
