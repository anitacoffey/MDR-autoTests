# This page is a work in progress. Many trade elements are yet to be added
class TradePage
  def initialize
    @trade_button = $browser.divs(class: 'navbar-start')[0].as(class: 'navbar-item')[0].click()

  #  @cash_transfers_button = $browser.divs(class: 'navbar-start')[0].as(class: 'navbar-item')[1].click()
  #  @settings_button = $browser.divs(class: 'navbar-start')[0].as(class: 'navbar-item')[2].click()
  #  @reports = $browser.divs(class: 'navbar-start')[0].as(class: 'navbar-item')[3].click()
    @Trade_Gold = $browser.divs(class: 'tabs is-centered')[0].link(text: 'Gold')
    @Trade_Silver = $browser.divs(class: 'tabs is-centered')[0].link(text: 'Silver')
    @Trade_Platinum = $browser.divs(class: 'tabs is-centered')[0].link(text: 'Platinum')

    @buy_first_metal = $browser.as(class: 'button is-success')[0].href
    @sell_first_metal = $browser.as(class: 'button is-danger')[0].href

    @dubai_hub = $browser.divs(class: 'control')[1].option(value: "32")
    @hongKong_hub = $browser.divs(class: 'control')[1].option(value: "23")
    @london_hub = $browser.divs(class: 'control')[1].option(value: "28")
    @newYork_hub = $browser.divs(class: 'control')[1].option(value: "27")
    @singapore_hub = $browser.divs(class: 'control')[1].option(value: "22")
    @sydney_hub = $browser.divs(class: 'control')[1].option(value: "25")
    @zurich_hub = $browser.divs(class: 'control')[1].option(value: "29")

    @order_quantity = $browser.td(class: 'input')[0].input(name: 'amount')

    @confirm_button = $browser.nuttons(class: 'button is-success')[1].buttons(text: 'Confirm')[0]

  #   @order_panel = $browser.div(class: 'column is-half')
  #   @market_order_button = @order_panel.button(text: 'Market')
  #   @market_order = $browser.find_element(name: 'Market')
  #   @limit_order_button = @order_panel.button(class: 'Limit')
  #   @cancel_button = $browser.div(text: 'button is-danger').find_element(text: "Cancel")
  #   @confirm_button = $browser.div(text: 'button is-success').find_element(text: "Confirm")
  #   @order_quantity_control = $browser.td(name: 'amount').text_field


    # @left_panel_headers = $browser.div(class: ['column-headers', 'left'])
    # @left_panel_contracts = $browser.div(class: 'left-col')
    # @left_contract_blocks = @left_panel_contracts.divs(class: 'product-datablock-summary-container')
    # @right_panel = $browser.div(class: ['column-headers', 'right'])
    # @left_filter_toggle = @left_panel_headers.link(class: 'filterToggle')
    # @left_product_filters = @left_panel_headers.div(class: ['product-filters', 'active'])
    # @left_mode_selector = @left_panel_headers.select_list(class: 'market-selector')
    # @left_hub_selector = @left_panel_headers.select_list(class: 'hub-selector')
    # @left_metal_selector = @left_panel_headers.select_list(class: 'metal-selector')
    # @buy_button = $browser.link(class: 'buy')
    # @sell_button = $browser.link(class: 'sell')
    # @market_order_button = $browser.link(class: 'orderForm__orderType--market')
    # @limit_order_button = $browser.link(class: 'orderForm__orderType--limit')
    # @order_quantity_control = $browser.fieldset(class: 'orderForm__quantitySpinner').text_field
    # @order_price_control = $browser.fieldset(class: 'orderForm__amountSpinner').text_field
    # @review_order_button = $browser.link(text: 'Review Order →')
    # @submit_order_button = $browser.link(text: 'Submit Order')
  end

  def insert_quantity(quantity)
    @order_quantity.click()
    @order_quantity.send_keys(quantity)
  end

  def top_sell_depth
    top_sell_depth_text = $browser.div(class: 'product-bid-offer').dl(class: 'bid').dd.link.text
    sell_depth_without_comma = top_sell_depth_text
                               .chars
                               .reject { |i| i == ',' }
                               .join

    sell_depth_without_comma.to_f
  end

  def top_buy_depth
    top_buy_depth_text = $browser.div(class: 'product-bid-offer').dl(class: 'offer').link(class: 'buy').text
    buy_depth_without_comma = top_buy_depth_text
                              .chars
                              .reject { |i| i == ',' }
                              .join

    buy_depth_without_comma.to_f
  end

  def set_order_price(direction, distance)
    elements = TradePage.new
    top_of_depth = if direction == 'buy'
                     elements.top_buy_depth
                   else
                     elements.top_sell_depth
  end
    direction == 'buy' ? top_of_depth - distance : top_of_depth + distance
  end

  def select_client_filter(client_hin)
    $browser.input(class: 'clientSelect__filterInput').click
    $browser.span(text: Regexp.new(client_hin)).click
  end

  def select_date_time_in_future
    $browser.link(class: 'orderForm__orderValidity--gtd').click
    $browser.fieldset(class: 'bc-group datetime-combo').click
    $browser.div(class: 'picker__nav--next').click
    $browser.div(class: 'picker__box').click
    $browser.fieldset(class: 'bc-group datetime-combo').input(class: 'timepicker').click
    $browser.ul(class: 'picker__list').li(index: 2).click
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

  attr_reader :left_panel_headers

  attr_reader :left_panel_contracts

  attr_reader :left_mode_selector

  attr_reader :left_product_filters

  attr_reader :left_filter_toggle

  attr_reader :left_metal_selector

  attr_reader :left_hub_selector

  attr_reader :buy_button

  attr_reader :sell_button

  attr_reader :market_order_button

  attr_reader :limit_order_button

  attr_reader :order_quantity_control

  attr_reader :review_order_button

  attr_reader :submit_order_button
end
