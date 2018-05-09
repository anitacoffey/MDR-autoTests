# This page is a work in progress. Many trade elements are yet to be added
class TradePage
  def initialize
    @left_panel_headers = $browser.div(class: ['column-headers', 'left'])
    @left_panel_contracts = $browser.div(class: 'left-col')
    @left_contract_blocks = @left_panel_contracts.divs(class: 'product-datablock-summary-container')
    @right_panel = $browser.div(class: ['column-headers', 'right'])
    @left_filter_toggle = @left_panel_headers.link(class: 'filterToggle')
    @left_product_filters = @left_panel_headers.div(class: ['product-filters', 'active'])
    @left_mode_selector = @left_panel_headers.select_list(class: 'market-selector')
    @left_hub_selector = @left_panel_headers.select_list(class: 'hub-selector')
    @left_metal_selector = @left_panel_headers.select_list(class: 'metal-selector')
    @buy_button = $browser.link(class: 'buy')
    @sell_button = $browser.link(class: 'sell')
    @market_order_button = $browser.link(class: 'orderForm__orderType--market')
    @limit_order_button = $browser.link(class: 'orderForm__orderType--limit')
    @order_quantity_control = $browser.fieldset(class: 'orderForm__quantitySpinner').text_field
    @order_price_control = $browser.fieldset(class: 'orderForm__amountSpinner').text_field
    @review_order_button = $browser.link(text: 'Review Order →')
    @submit_order_button = $browser.link(text: 'Submit Order')
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

  def select_client_filter(client_hin)
    $browser.input(class: 'clientSelect__filterInput').click
    $browser.span(text: Regexp.new(client_hin)).click
  end

  def select_date_time
    $browser.link(class: 'orderForm__orderValidity--gtd').click
    $browser.fieldset(class: 'bc-group datetime-combo').click
    $browser.div(class: 'picker__nav--next').click
    # $browser.div(class: 'picker__day picker__day--infocus picker__day--today').tr(index: 2).td(index: 2).click
    # $browser.div(class: 'picker__box').tr(index: 2).td(index: 2).click
    $browser.div(class: 'picker__box').click
    $browser.fieldset(class: 'bc-group datetime-combo').input(class: 'timepicker').click
    $browser.ul(class: 'picker__list').li(index: 2).click
  end

  attr_reader :order_price_control

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
