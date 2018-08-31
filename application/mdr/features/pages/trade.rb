# This page is a work in progress. Many trade elements are yet to be added
class TradePage
  def initialize
    @trade_button = $browser.divs(class: 'navbar-start')[0].as(class: 'navbar-item')[0].click()
    @Trade_Gold = $browser.divs(class: 'tabs is-centered')[0].link(text: 'Gold')
    @Trade_Silver = $browser.divs(class: 'tabs is-centered')[0].link(text: 'Silver')
    @Trade_Platinum = $browser.divs(class: 'tabs is-centered')[0].link(text: 'Platinum')

    @buy_first_metal = $browser.ps(text: 'Buy')[0]
    @sell_first_metal = $browser.ps(text: 'Sell')[0]

    @dubai_hub = $browser.divs(class: 'control')[1].option(value: "32")
    @hongKong_hub = $browser.divs(class: 'control')[1].option(value: "23")
    @london_hub = $browser.divs(class: 'control')[1].option(value: "28")
    @newYork_hub = $browser.divs(class: 'control')[1].option(value: "27")
    @singapore_hub = $browser.divs(class: 'control')[1].option(value: "22")
    @sydney_hub = $browser.divs(class: 'control')[1].option(value: "25")
    @zurich_hub = $browser.divs(class: 'control')[1].option(value: "29")

    @order_quantity = $browser.input(name: 'amount')

    @confirm_button = $browser.buttons(text: 'Confirm')[0]

  end

  attr_reader :order_price_control

  attr_reader :Trade_Gold

  attr_reader :Trade_Silver

  attr_reader :Trade_Platinum

  attr_reader :dubai_hub

  attr_reader :hongKong_hub

  attr_reader :london_hub

  attr_reader :newYork_hub

  attr_reader :singapore_hub

  attr_reader :sydney_hub

  attr_reader :zurich_hub

  attr_reader :buy_first_metal

  attr_reader :sell_first_metal

  attr_reader :order_quantity

  attr_reader :confirm_button
end
