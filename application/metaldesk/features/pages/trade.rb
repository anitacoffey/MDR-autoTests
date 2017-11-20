# This page is a work in progress. Many trade elements are yet to be added
class UIElements_TradeRefactor
  def initialize
    @left_panel_headers = $browser.div(class: 'column-headers left')
    @left_panel_contracts = $browser.div(class: 'left-col')
    @left_contract_blocks = @left_panel_contracts.divs(class: 'product-datablock-summary-container')
    @right_panel = $browser.div(class: 'column-headers right')
    @left_filter_toggle = @left_panel_headers.link(class: 'filterToggle')
    @left_product_filters = @left_panel_headers.div(class: 'product-filters active')
    @left_mode_selector = @left_panel_headers.select_list(class: 'market-selector')
    @left_hub_selector = @left_panel_headers.select_list(class: 'hub-selector')
    @left_metal_selector = @left_panel_headers.select_list(class: 'metal-selector')
    @buy_button = $browser.link(class: 'buy')
    @sell_button = $browser.link(class: 'sell')
    @market_order_button = $browser.link(class: 'orderForm__orderType--market')
    @limit_order_button = $browser.link(class: 'orderForm__orderType--limit')
    @order_quantity_control = $browser.fieldset(class: 'orderForm__quantitySpinner').text_field
    @review_order_button = $browser.link(text: 'Review Order →')
    @submit_order_button = $browser.link(text: 'Submit Order')
  end

  def left_panel_headers
    @left_panel_headers
  end

  def left_panel_contracts
    @left_panel_contracts
  end

  def left_mode_selector
    @left_mode_selector
  end

  def left_product_filters
    @left_product_filters
  end

  def left_filter_toggle
    @left_filter_toggle
  end

  def left_metal_selector
    @left_metal_selector
  end

  def left_hub_selector
    @left_hub_selector
  end

  def buy_button
    @buy_button
  end

  def sell_button
    @sell_button
  end

  def market_order_button
    @market_order_button
  end

  def limit_order_button
    @limit_order_button
  end

  def order_quantity_control
    @order_quantity_control
  end

  def review_order_button
    @review_order_button
  end

  def submit_order_button
    @submit_order_button
  end
end
