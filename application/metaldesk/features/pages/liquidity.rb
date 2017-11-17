class LiquidityPage
  def initialize
    @hub_filter = $browser.div(:class=>'md-hubs-input').input(:class=>'hubSelect__filterInput')
    @hub_list = $browser.div(:class=>'hubSelect__hubsList')
    @metal_filter = $browser.div(:class=>'md-product-metals')
    @product_list = $browser.div(:class => 'liquidityPage__leftSidebarContainer').div(:class => 'scrollview-content')
    @kill_all_btn = $browser.a(:text => 'Kill All Spread Orders')
    @quantity_input = $browser.fieldset(:class => 'orderForm__quantitySpinner').input
    @value_input = $browser.fieldset(:class => 'orderForm__amountSpinner').input
    @review_order_btn = $browser.a(:text => 'Review Order →')
    @confirm_placement_btn = $browser.a(:text => 'Confirm Placement')
    @depth_container = $browser.div(:class => 'liquidityPage__depthContainer')
    @return_to_order_screen_btn = $browser.a(:text => 'Return to order screen→')
    @cancel_below_spread_orders_btn = $browser.a(:text => 'Cancel Below Spread Orders →')
    @cancellation_complete = $browser.div(:text => 'Completed Order Cancellation.')
    @review_update_btn = $browser.a(:text => 'Review Update →')
    @confirm_update_btn = $browser.a(:text => 'Confirm Update')
    @value_btn = $browser.a(:text => '$')
    @percent_btn = $browser.a(:text => '%')
    @offer_btn = $browser.a(:text => 'Offer')
    @active_hours_btn = $browser.a(:text => 'Active Hours')
    @open_time = $browser.fieldset(:class => 'bc-group datetime-combo').input(:placeholder => 'Open Time')
    @close_time = $browser.fieldset(:class => 'bc-group datetime-combo').input(:placeholder => 'Close Time')
    @time_zone = $browser.fieldset(:class => 'bc-group datetime-combo').div(:class => 'selectize-input')
  end

  def hub_filter
    @hub_filter
  end

  def filter_hub(index)
    @hub_list.ul.li(:index=>index)
  end

  def filter_metal(index)
    @metal_filter.nav.a(:index=>index).span(:class=>'square-checkbox')
  end

  def select_product (index)
    @product_list.div(:class => 'liquidityPage__sidebarItem--container', :index => index)
  end

  def cancellation_complete
    @cancellation_complete
  end

  def kill_all_btn
    @kill_all_btn
  end

  def review_order_btn
    @review_order_btn
  end

  def quantity_input
    @quantity_input
  end

  def value_input
    @value_input
  end

  def confirm_placement_btn
    @confirm_placement_btn
  end

  def depth_container
    @depth_container
  end

  def depth_collection(type)
    @depth_container.div(:class => 'liquidityPage__depth--' + type).parent.divs(:class => 'liquidityPage__depth--depthItem')
  end

  def depth_qty(type,index)
    @depth_container.div(:class => 'liquidityPage__depth--' + type).parent.div(:class => 'liquidityPage__depth--depthItem', :index => index).tr(:index => 0).td(:index => 1)
  end

  def depth_value(type,index)
    @depth_container.div(:class => 'liquidityPage__depth--' + type).parent.div(:class => 'liquidityPage__depth--depthItem', :index => index).tr(:index => 1).td(:index => 1)
  end

  def active_value(type,index)
    @depth_container.div(:class => 'liquidityPage__depth--' + type).parent.div(:class => 'liquidityPage__depth--depthItem', :index => index).tr(:index => 3).td(:index => 1)
  end

  def return_to_order_screen_btn
    @return_to_order_screen_btn
  end

  def cancel_btn(type,index)
    @depth_container.div(:class => 'liquidityPage__depth--' + type).parent.div(:class => 'liquidityPage__depth--depthItem', :index => index).a(:text => 'Cancel Order')
  end

  def cancel_below_spread_orders_btn
    @cancel_below_spread_orders_btn
  end

  def update_btn(type,index)
    @depth_container.div(:class => 'liquidityPage__depth--' + type).parent.div(:class => 'liquidityPage__depth--depthItem', :index => index).a(:text => 'Edit Order')
  end

  def review_update_btn
    @review_update_btn
  end

  def confirm_update_btn
    @confirm_update_btn
  end

  def value_btn
    @value_btn
  end

  def percent_btn
    @percent_btn
  end

  def offer_btn
    @offer_btn
  end

  def active_hours_btn
    @active_hours_btn
  end

  def open_time
    @open_time
  end

  def open_time_value
    $browser.fieldset(:class => 'bc-group datetime-combo').input(:placeholder => 'Open Time').parent.div(:class => 'picker picker--time', :index => 0).ul.li(:text => '09:00')
  end

  def close_time
    @close_time
  end

  def close_time_value
    $browser.fieldset(:class => 'bc-group datetime-combo').input(:placeholder => 'Close Time').parent.div(:class => 'picker picker--time', :index => 1).ul.li(:text => '17:00')
  end

  def time_zone
    @time_zone
  end

  def time_zone_value
    $browser.fieldset(:class => 'bc-group datetime-combo').div(:class => 'selectize-input').parent.div(:class => 'ui-select-choices').div(:class => 'ui-select-choices-row', :index => 40)
  end

  def get_product
    $browser.div(:class=>'liquidityPage__depth--header').h2
  end

  def get_hub
    $browser.div(:class=>'liquidityPage__depth--header').small
  end
end
