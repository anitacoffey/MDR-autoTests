class LiquidityPage
  def initialize
    @hub_filter = $browser.div(class: 'md-hubs-input').input(class: 'hubSelect__filterInput')
    @hub_list = $browser.div(class: 'hubSelect__hubsList')
    @metal_filter = $browser.div(class: 'md-product-metals')
    @product_list = $browser.div(class: 'liquidityPage__leftSidebarContainer').div(class: 'scrollview-content')
    @kill_all_btn = $browser.a(text: 'Kill All Spread Orders')
    @quantity_input = $browser.fieldset(class: 'orderForm__quantitySpinner').input
    @value_input = $browser.fieldset(class: 'orderForm__amountSpinner').input
    @review_order_btn = $browser.a(text: 'Review Order →')
    @confirm_placement_btn = $browser.a(text: 'Confirm Placement')
    @depth_container = $browser.div(class: 'liquidityPage__depthContainer')
    @return_to_order_screen_btn = $browser.a(text: 'Return to order screen→')
    @cancel_below_spread_orders_btn = $browser.a(text: 'Cancel Below Spread Orders →')
    @cancellation_complete = $browser.div(text: 'Completed Order Cancellation.')
    @review_update_btn = $browser.a(text: 'Review Update →')
    @confirm_update_btn = $browser.a(text: 'Confirm Update')
    @value_btn = $browser.a(text: '$')
    @percent_btn = $browser.a(text: '%')
    @offer_btn = $browser.a(text: 'Offer')
    @active_hours_btn = $browser.a(text: 'Active Hours')
    @open_time = $browser.input(placeholder: 'Open Time')
    @close_time = $browser.input(placeholder: 'Close Time')
    @time_zone = $browser.fieldset(class: 'bc-group datetime-combo').div(class: 'selectize-input')
  end

  attr_reader :hub_filter

  def filter_hub(index)
    @hub_list.ul.li(index: index)
  end

  def filter_metal(index)
    @metal_filter.nav.a(index: index).span(class: 'square-checkbox')
  end

  def select_product(index)
    @product_list.div(class: 'liquidityPage__sidebarItem--container', index: index)
  end

  attr_reader :cancellation_complete

  attr_reader :kill_all_btn

  attr_reader :review_order_btn

  attr_reader :quantity_input

  attr_reader :value_input

  attr_reader :confirm_placement_btn

  attr_reader :depth_container

  def depth_collection(type)
    @depth_container
      .div(class: 'liquidityPage__depth--' + type)
      .parent
      .divs(class: 'liquidityPage__depth--depthItem')
  end

  def depth_qty(type, index)
    @depth_container
      .div(class: 'liquidityPage__depth--' + type)
      .parent
      .div(class: 'liquidityPage__depth--depthItem', index: index)
      .tr(index: 0)
      .td(index: 1)
  end

  def depth_value(type, index)
    @depth_container
      .div(class: 'liquidityPage__depth--' + type)
      .parent
      .div(class: 'liquidityPage__depth--depthItem', index: index)
      .tr(index: 1)
      .td(index: 1)
  end

  def active_value(type, index)
    @depth_container
      .div(class: 'liquidityPage__depth--' + type)
      .parent.div(class: 'liquidityPage__depth--depthItem', index: index)
      .tr(index: 3)
      .td(index: 1)
  end

  attr_reader :return_to_order_screen_btn

  def cancel_btn(type, index)
    @depth_container
      .div(class: 'liquidityPage__depth--' + type)
      .parent
      .div(class: 'liquidityPage__depth--depthItem', index: index)
      .a(text: 'Cancel Order')
  end

  attr_reader :cancel_below_spread_orders_btn

  def update_btn(type, index)
    @depth_container
      .div(class: 'liquidityPage__depth--' + type)
      .parent
      .div(class: 'liquidityPage__depth--depthItem', index: index)
      .a(text: 'Edit Order')
  end

  attr_reader :review_update_btn

  attr_reader :confirm_update_btn

  attr_reader :value_btn

  attr_reader :percent_btn

  attr_reader :offer_btn

  attr_reader :active_hours_btn

  attr_reader :open_time

  def open_time_value
    $browser
      .input(placeholder: 'Open Time')
      .parent
      .divs(class: ['picker', 'picker--time'])[0]
      .ul
      .li(text: '09:00')
  end

  attr_reader :close_time

  def close_time_value
    $browser
      .input(placeholder: 'Close Time')
      .parent
      .divs(class: ['picker', 'picker--time'])[1]
      .ul
      .li(text: '17:00')
  end

  attr_reader :time_zone

  def time_zone_value
    $browser
      .fieldset(class: ['bc-group', 'datetime-combo'])
      .div(class: 'selectize-input')
      .parent
      .div(class: 'ui-select-choices')
      .div(class: 'ui-select-choices-row', index: 40)
  end

  def find_product
    $browser.div(class: 'liquidityPage__depth--header').h2
  end

  def find_hub
    $browser.div(class: 'liquidityPage__depth--header').small
  end
end
