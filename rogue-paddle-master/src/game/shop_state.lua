local ShopState = {
  title = Reactive.useCell 'Gift Shop',
  subtitle = Reactive.useCell 'Starter Gifts',
  coins = Reactive.useCell(0),
  offer_1 = Reactive.useCell 'Wide Paddle - 20',
  offer_2 = Reactive.useCell 'Quick Hands - 20',
  offer_3 = Reactive.useCell 'Lucky Gift - 12',
  footer = Reactive.useCell 'Shop opens after each level clear.',
}

return ShopState
