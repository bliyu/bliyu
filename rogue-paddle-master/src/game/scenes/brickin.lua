return function()
  local state = {}
  local stat = require 'game.stats'
  local Audio = require 'audio'
  local Progress = require 'game.progress'
  local ShopState = require 'game.shop_state'
  local Presentation = require 'game.presentation'
  local round = Cell.new(1)
  local shop_title = Cell.new 'SHOP'
  local shop_subtitle = Cell.new 'Gift shop'
  local shop_message = Cell.new 'Spend coins before the next wave.'
  local offer_1_label = Cell.new ''
  local offer_2_label = Cell.new ''
  local offer_3_label = Cell.new ''
  local shop_open = false
  local shop_pending = false
  stat.lives.set(3)
  stat.msg.set('SPACE TO\nSTART')
  stat.score.set(0)
  stat.coins.set(0)
  stat.level.set(1)

  local paddle = require 'game.entities.paddle' {
    pos = Vec2.new(S.camera.box.w / 2, S.camera.box.h - 18),
    starting_origin = Origin.BOTTOM_CENTER,
  }
  local paddle_base_width = paddle.sprite.box.w
  local paddle_base_speed = paddle.speed
  local upgrades = {
    wide = 0,
    speed = 0,
    serve = 0,
    shield = 0,
  }

  local ball = require 'game.entities.ball' {}
  local ball_base_speed = ball.speed
  local shake = S.camera.shake
  local bricks = require('game.brick_manager').new {
    colors = {
      Color.REGULAR1,
      Color.REGULAR3,
      Color.REGULAR2,
      Color.REGULAR4,
    },
    layout = Res.layouts.LEVEL_1,
    variants = {},
    top_offset = 2,
    onGenerate = function(brick) end,
    onReset = function(e)
      stat.score.set(stat.score.get() + 100)
      stat.coins.set(stat.coins.get() + 25)
      shop_pending = true
      e.cancel = true
    end,
    onRemove = function(e, brick)
      stat.score.set(stat.score.get() + 10)
      stat.coins.set(stat.coins.get() + 2)
      Audio.play 'brick'
      state.bumpCamera(1.2, 0.09)
    end,
    onSpawn = function(e, brick) end,
    viewTransitionSpeed = 1.0,
  }

  state.currentLevel = function()
    return math.min(round.get(), 3)
  end

  state.currentLayout = function()
    return Res.layouts['LEVEL_' .. state.currentLevel()]
  end

  state.offerForLevel = function()
    local level = state.currentLevel()

    if level == 1 then
      return {
        title = 'Starter Gifts',
        offers = {
          {
            label = string.format('Wide Paddle Lv.%d  (%d)', upgrades.wide + 1, 20 + upgrades.wide * 15),
            cost = 20 + upgrades.wide * 15,
            buy = function()
              upgrades.wide = upgrades.wide + 1
              state.applyUpgrades()
              shop_message.set('Your paddle got wider.')
            end,
          },
          {
            label = string.format('Quick Hands Lv.%d  (%d)', upgrades.speed + 1, 20 + upgrades.speed * 15),
            cost = 20 + upgrades.speed * 15,
            buy = function()
              upgrades.speed = upgrades.speed + 1
              state.applyUpgrades()
              shop_message.set('Your paddle got faster.')
            end,
          },
          {
            label = 'Lucky Gift +15 Coins  (12)',
            cost = 12,
            buy = function()
              stat.coins.set(stat.coins.get() + 15)
              shop_message.set('You found a lucky coin gift.')
            end,
          },
        },
      }
    elseif level == 2 then
      return {
        title = 'Arcade Gifts',
        offers = {
          {
            label = 'Heart Box +1 Life  (28)',
            cost = 28,
            buy = function()
              stat.lives.set(math.min(stat.lives.get() + 1, 5))
              shop_message.set('You gained a bonus life.')
            end,
          },
          {
            label = string.format('Power Serve Lv.%d  (%d)', upgrades.serve + 1, 24 + upgrades.serve * 18),
            cost = 24 + upgrades.serve * 18,
            buy = function()
              upgrades.serve = upgrades.serve + 1
              shop_message.set('Launches will now feel faster.')
            end,
          },
          {
            label = 'Coin Crate +30 Coins  (20)',
            cost = 20,
            buy = function()
              stat.coins.set(stat.coins.get() + 30)
              shop_message.set('A coin crate paid out big.')
            end,
          },
        },
      }
    else
      return {
        title = 'Rare Gift Shop',
        offers = {
          {
            label = 'Shield Charm  (30)',
            cost = 30,
            buy = function()
              upgrades.shield = upgrades.shield + 1
              shop_message.set('A miss will be blocked once.')
            end,
          },
          {
            label = string.format('Mega Paddle Lv.%d  (%d)', upgrades.wide + 1, 28 + upgrades.wide * 18),
            cost = 28 + upgrades.wide * 18,
            buy = function()
              upgrades.wide = upgrades.wide + 1
              state.applyUpgrades()
              shop_message.set('Your paddle grew even more.')
            end,
          },
          {
            label = 'Jackpot Gift +50 Coins  (32)',
            cost = 32,
            buy = function()
              stat.coins.set(stat.coins.get() + 50)
              shop_message.set('Jackpot. Coins everywhere.')
            end,
          },
        },
      }
    end
  end

  state.refreshShopLabels = function()
    local shop = state.offerForLevel()
    shop_subtitle.set(shop.title)
    ShopState.title.set('GIFT SHOP')
    ShopState.subtitle.set(shop.title)
    ShopState.coins.set(stat.coins.get())
    offer_1_label.set(shop.offers[1].label)
    offer_2_label.set(shop.offers[2].label)
    offer_3_label.set(shop.offers[3].label)
    ShopState.offer_1.set(shop.offers[1].label)
    ShopState.offer_2.set(shop.offers[2].label)
    ShopState.offer_3.set(shop.offers[3].label)
    ShopState.footer.set('')
  end

  state.buyOffer = function(idx)
    local shop = state.offerForLevel()
    local offer = shop.offers[idx]

    if stat.coins.get() < offer.cost then
      shop_message.set('Not enough coins for that gift.')
      Audio.play 'wall'
      return
    end

    stat.coins.set(stat.coins.get() - offer.cost)
    offer.buy()
    state.refreshShopLabels()
    ShopState.coins.set(stat.coins.get())
    Audio.play 'paddle'
  end

  state.applyUpgrades = function()
    local bottom_center = paddle.sprite.box:getOriginPos(Origin.BOTTOM_CENTER)
    paddle.sprite.box.w = paddle_base_width + upgrades.wide * 8
    paddle.sprite.box:setPos(bottom_center, Origin.BOTTOM_CENTER)
    paddle.speed = paddle_base_speed * (1 + upgrades.speed * 0.18)
    paddle.sprite.box:clampWithin(S.camera.box, true, true, true, true)
  end

  state.openShop = function(ctx)
    if shop_open then
      return
    end

    shop_pending = false
    shop_open = true
    ctx.shop_locked = true
    shop_title.set(string.format('SHOP  LEVEL %d CLEARED', state.currentLevel()))
    shop_message.set('Pick a gift before the next wave.')
    state.refreshShopLabels()
    ctx:setOverlay(require 'game.overlays.shop' {
      title = shop_title,
      subtitle = shop_subtitle,
      coins = stat.coins,
      message = shop_message,
      offer_1_label = offer_1_label,
      offer_2_label = offer_2_label,
      offer_3_label = offer_3_label,
      on_buy_1 = function()
        state.buyOffer(1)
      end,
      on_buy_2 = function()
        state.buyOffer(2)
      end,
      on_buy_3 = function()
        state.buyOffer(3)
      end,
      on_continue = function()
        state.startNextWave(ctx)
      end,
    })
  end

  state.startNextWave = function(ctx)
    local next_level = math.min(round.get() + 1, 3)
    local saved_on_reset = bricks.state.onReset

    shop_open = false
    shop_pending = false
    ctx.shop_locked = false
    round.set(next_level)
    stat.level.set(next_level)
    bricks:setLayout(Res.layouts['LEVEL_' .. next_level])
    bricks.state.onReset = nil
    bricks:reset()
    bricks.state.onReset = saved_on_reset
    stat.msg.set('SPACE TO\nSTART')

    if ctx:hasOverlay() then
      ctx:popOverlay()
    end

    ctx:setStatus(state.ATTACHED)
  end

  state.pushTrail = function()
    table.insert(ball.trail, 1, {
      box = ball.sprite.box:clone(),
      life = 1,
    })

    while #ball.trail > 6 do
      table.remove(ball.trail)
    end
  end

  state.updateTrail = function(dt)
    for i = #ball.trail, 1, -1 do
      local ghost = ball.trail[i]
      ghost.life = ghost.life - dt * 6
      if ghost.life <= 0 then
        table.remove(ball.trail, i)
      end
    end
  end

  state.clearTrail = function()
    ball.trail = {}
  end

  state.bumpCamera = function(strength, duration)
    shake.strength = math.max(shake.strength, strength)
    shake.duration = duration
    shake.time = duration
  end

  state.updatePaddleInput = function()
    paddle.input_x = 0

    if love.keyboard.isDown(unpack(Res.keybinds.MOVE_RIGHT)) then
      paddle.input_x = paddle.input_x + 1
    end

    if love.keyboard.isDown(unpack(Res.keybinds.MOVE_LEFT)) then
      paddle.input_x = paddle.input_x - 1
    end
  end

  state.movePaddle = function(dt)
    paddle.prev_box:copy(paddle.sprite.box)
    paddle.sprite.box.x = paddle.sprite.box.x + paddle.input_x * dt * paddle.speed
    paddle.sprite.box:clampWithin(S.camera.box, true, true, true, true)
  end

  state.ATTACHED = Status.new {
    ui = stat.hud,

    init = function()
      state.applyUpgrades()
      state.clearTrail()
      paddle.prev_box:copy(paddle.sprite.box)
      ball.sprite.box:setPos(
        paddle.sprite.box:getOriginPos(Origin.TOP_CENTER),
        Origin.BOTTOM_CENTER
      )
      ball.prev_box:copy(ball.sprite.box)
    end,

    update = function(ctx, dt)
      if ctx:hasOverlay() then
        return
      end

      state.updatePaddleInput()

      if love.keyboard.isPressed(Res.keybinds.CONFIRM) and not ctx:hasOverlay() then
        Audio.play 'launch'
        ctx:setStatus(state.PLAYING)
      end
    end,

    fixed = function(ctx, dt)
      if ctx:hasOverlay() then
        return
      end

      state.updateTrail(dt)
      state.movePaddle(dt)
      ball.prev_box:copy(ball.sprite.box)
      ball.sprite.box:setPos(
        paddle.sprite.box:getOriginPos(Origin.TOP_CENTER),
        Origin.BOTTOM_CENTER
      )
    end,

    draw = function(ctx)
      state.drawLevel()
    end,
  }

  state.PLAYING = Status.new {
    ui = stat.hud,

    init = function()
      stat.msg.set(nil)
      state.clearTrail()
      ball.speed = ball_base_speed * (1 + (state.currentLevel() - 1) * 0.12 + upgrades.serve * 0.06)
      ball.velocity = Vec2.new((math.random() < 0.5 and 1.0 or -1.0), -1.0):normalize()
    end,

    update = function(ctx, dt)
      if ctx:hasOverlay() then
        return
      end

      state.updatePaddleInput()

      if Res.cheats then
        state.updateCheats()
      end
    end,

    fixed = function(ctx, dt)
      if ctx:hasOverlay() then
        return
      end

      ball.prev_box:copy(ball.sprite.box)
      state.updateTrail(dt)

      state.movePaddle(dt)

      ball.sprite.box.pos = ball.sprite.box.pos + ball.velocity * dt * ball.speed
      state.pushTrail()

      local x_within, y_within = ball.sprite.box:within(S.camera.box)

      if not x_within then
        ball.velocity.x = -ball.velocity.x
        ball.sprite.box:clampWithinX(S.camera.box, true, true)
        Audio.play 'wall'
        state.bumpCamera(1.0, 0.08)
      end

      if not y_within then
        local top, bottom = ball.sprite.box:clampWithinY(S.camera.box, true, false)

        if top then
          ball.velocity.y = 1
          Audio.play 'wall'
          state.bumpCamera(1.0, 0.08)
        end

        if bottom then
          state.removeLife(ctx)
        end
      end

      bricks:removeOnCollision(ball.sprite.box, ball.velocity)
      if paddle.sprite.box:paddleOnCollision(ball.sprite.box, ball.velocity) then
        Audio.play 'paddle'
        state.bumpCamera(0.8, 0.06)
      end

      if shop_pending and not ctx:hasOverlay() then
        state.openShop(ctx)
      end
    end,

    draw = function()
      state.drawLevel()
    end,
  }

  state.drawLevel = function()
    Presentation.drawPlayfield(state.currentLevel(), round.get())
    bricks:draw()

    love.graphics.setColor(Color.SHADOW[1], Color.SHADOW[2], Color.SHADOW[3], 0.7)
    love.graphics.rectangle(
      'fill',
      paddle.sprite.box.pos.x + 2,
      paddle.sprite.box.pos.y + 3,
      paddle.sprite.box.size.x,
      paddle.sprite.box.size.y,
      4,
      4
    )
    paddle.sprite:drawLerp(paddle.prev_box)

    for i = #ball.trail, 1, -1 do
      local ghost = ball.trail[i]
      ball.sprite.data:drawFrom(ghost.box, {
        frame_idx = ball.sprite.style.frame_idx,
        flip_x = ball.sprite.style.flip_x,
        flip_y = ball.sprite.style.flip_y,
        color = { Color.CYAN[1], Color.CYAN[2], Color.CYAN[3], 0.08 + ghost.life * 0.22 },
      })
    end

    love.graphics.setColor(Color.CYAN[1], Color.CYAN[2], Color.CYAN[3], 0.18)
    love.graphics.circle(
      'fill',
      ball.sprite.box.pos.x + ball.sprite.box.size.x / 2,
      ball.sprite.box.pos.y + ball.sprite.box.size.y / 2,
      6
    )
    ball.sprite:drawLerp(ball.prev_box)
  end

  ---@param ctx StatusCtx
  state.removeLife = function(ctx)
    if upgrades.shield > 0 then
      upgrades.shield = upgrades.shield - 1
      shop_message.set('Shield charm saved you.')
      ball.velocity = Vec2.zero()
      ctx:setStatus(state.ATTACHED)
      return
    end

    stat.lives.set(stat.lives.get() - 1)
    state.clearTrail()
    state.bumpCamera(1.6, 0.18)
    Audio.play 'lose_life'

    if stat.lives.get() == 0 then
      Progress.recordRun(stat.score.get(), stat.coins.get(), stat.level.get())
      Audio.play 'game_over'
      ctx.shop_locked = true
      ctx:setOverlay(require 'game.overlays.gameover')
    else
      stat.msg.set('SPACE TO\nCONTINUE')
      ctx:setStatus(state.ATTACHED)
    end
  end

  state.updateCheats = function()
    if love.keyboard.isPressed 'r' then
      bricks:reset()
    end

    if love.mouse.isDown(2) then
      ball.sprite.box.pos:copy(S.cursor.pos)
    end
  end

  local scene = Scene.new {
    status = state.ATTACHED,
    overlay = require 'game.overlays.title' {
      on_start = function()
        local ctx = S.getCtx()
        if ctx and ctx:hasOverlay() then
          ctx.shop_locked = false
          ctx:popOverlay()
        end
        stat.msg.set('SPACE TO\nLAUNCH')
      end,
    },
    update = function(ctx)
      if love.keyboard.isPressed(Res.keybinds.PAUSE) and stat.lives.get() > 0 and not shop_open and not ctx.shop_locked then
        stat.togglePauseOverlay()
      end
    end,
  }

  scene.ctx.shop_locked = true
  return scene
end
