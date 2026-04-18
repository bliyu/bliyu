local Ui = require 'ui.registry'
local UiStyle = require 'ui.style'

---@alias TextAccepted string | number | nil
---@alias TextFont love.Font

---@class Fragment : UiType
---@field val Cell<TextAccepted>
---@field font TextFont
---@field max_width? UiUnit
---@field align "left"|"center"|"right"
local Fragment = {}
Fragment.__index = Fragment

---@param font love.Font
---@param val TextAccepted
---@param max_width? UiUnit
---@return number, number
local function getSize(val, font, max_width)
  if not val then
    return 0, 0
  end

  local text = tostring(val)
  local limit = max_width and UiStyle.calculateUnit(max_width) or nil
  if limit and limit > 0 then
    local _, wrapped = font:getWrap(text, limit)
    local lines = math.max(#wrapped, 1)
    return limit, lines * font:getHeight()
  end

  return font:getWidth(text), font:getHeight()
end

---@class FragmentBuilder
---@field val Cell<TextAccepted>|TextAccepted
---@field font? TextFont
---@field max_width? string|number
---@field align? "left"|"center"|"right"
---@field state? UiState

---@param build FragmentBuilder
---@return UiId<Fragment>
Fragment.new = function(build)
  ---@type Fragment
  local self = {
    font = build.font or love.graphics.getFont(),
    val = Cell.optional(build.val) --[[@as Cell<TextAccepted>]],
    max_width = build.max_width and UiStyle.parse(build.max_width) or nil,
    align = build.align or 'left',
  }

  local reactiveVal = Reactive.fromState(self.val)
  if reactiveVal then
    reactiveVal.subscribe(function()
      local node = Ui.get(self.node)
      if node then
        Ui.layout(node, node.view.parent, true)
      end
    end)
  end

  return Ui.add(self, {
    status = build.state,
    events = {
      draw = function(view)
        local val = self.val.get()
        if val then
          love.graphics.printf(
            tostring(val),
            self.font,
            view.box.pos.x,
            view.box.pos.y,
            view.box.size.x,
            self.align
          )
        end
      end,
      size = function(view)
        local w, h = getSize(self.val.get(), self.font, self.max_width)
        view.box.w = w
        view.box.h = h
      end,
    },
  })
end

return Fragment
