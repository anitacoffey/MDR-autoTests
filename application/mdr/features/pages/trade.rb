# This page is a work in progress. Many trade elements are yet to be added
class TradePage
  def initialize
    @trade_button = $browser.divs(class: 'navbar-start')[0].as(class: 'navbar-item')[0].click()

  #  @cash_transfers_button = $browser.divs(class: 'navbar-start')[0].as(class: 'navbar-item')[1].click()
  #  @settings_button = $browser.divs(class: 'navbar-start')[0].as(class: 'navbar-item')[2].click()
  #  @reports = $browser.divs(class: 'navbar-start')[0].as(class: 'navbar-item')[3].click()
    @Trade_Gold = $browser.divs(class: 'is-centered')[0].as(href: 'Gold')
    @Trade_Silver = $browser.divs(class: 'is-centered')[0].as(href: 'Silver')
    @Trade_Platinum = $browser.divs(class: 'is-centered')[0].as(href: 'Platinum')

  #  #buy dubai Gold 1kg bar 995 , sell dubai gold Wholesale AAU 10kg
  #   @buy_kg995_Gold_Dubai = $browser.div(class: 'button is-success').find_element(xPath: "//a[@href = 'trade/613/trade']")
    # @sell_wholesale_Gold_Dubai = $browser.div(class: 'button is-danger').find_element(xPath: "//a[@href = 'trade/639/trade']")
  #   #buy hong kong Swiss Gold 10oz,  sell Hong Kong swiss 100g Gold
  #   @buy_Swiss_10oz_Gold_HongKong = $browser.div(class: 'button is-success').find_element(xPath: "//a[@href = 'trade/271/trade']")
  #   @sell_Swiss_100g_Gold_HongKong  = $browser.div(class: 'button is-danger').find_element(xPath: "//a[@href = 'trade/626/trade']")
  #   #buy New York 1kg Silver, sell New York 100 oz Silver
  #   @buy_1kg_Silver_NewYork = $browser.div(class: 'button is-success').find_element(xPath: "//a[@href = 'trade/522/trade']")
  #   @sell_100oz_Silver_NewYork  = $browser.div(class: 'button is-danger').find_element(xPath: "//a[@href = 'trade/526/trade']")
  #   #buy Singapore Wholesale AAG 25000 oz Silver
  #   @buy_Wholesale_Silver_Singapore = $browser.div(class: 'button is-success').find_element(xPath: "//a[@href = 'trade/522/trade']")
  #   #buy London 1Kg platinum
  #   @buy_kg_Platinum_London = $browser.div(class: 'button is-success').find_element(xPath: "//a[@href = 'trade/549/trade']")
  #   #buy sell Syndey platinum
  #   @sell_kg_Platinum_Sydney = $browser.div(class: 'button is-success').find_element(xPath: "//a[@href = 'trade/324/trade']")
  #   #buy sell Zurich platinum
  #   @buy_kg_Platinum_Zurich = $browser.div(class: 'button is-success').find_element(xPath: "//a[@href = 'trade/552/trade']")
  #   #Select first buy / sell in the list
  #   #Gold = dubai/ hongkong
  #   #Silver = New York, Singapore
  #   #Platinum = London, Sydney, Zurich
  #   @buy_Gold_Dubai = $browser.div(class: 'button is-success').find_element(xPath: "//a[@href = 'trade/613/trade']")
  #   @sell_Gold_Dubai = $browser.div(class: 'button is-danger').find_element(xPath: "//a[@href = 'trade/613/trade']")
  #   @buy_Gold_HongKong = $browser.div(class: 'button is-success').find_element(xPath: "//a[@href = 'trade/264/trade']")
  #   @sell_Gold_HongKong  = $browser.div(class: 'button is-danger').find_element(xPath: "//a[@href = 'trade/264/trade']")
  #   @buy_Silver_NewYork = $browser.div(class: 'button is-success').find_element(xPath: "//a[@href = 'trade/522/trade']")
  #   @sell_Silver_NewYork  = $browser.div(class: 'button is-danger').find_element(xPath: "//a[@href = 'trade/522/trade']")
  #   @buy_Silver_Singapore = $browser.div(class: 'button is-success').find_element(xPath: "//a[@href = 'trade/251/trade']")
  #   @sell_Silver_Singapore  = $browser.div(class: 'button is-danger').find_element(xPath: "//a[@href = 'trade/251/trade']")
  #   @buy_Platinum_London = $browser.div(class: 'button is-success').find_element(xPath: "//a[@href = 'trade/549/trade']")
  #   @sell_Platinum_London = $browser.div(class: 'button is-danger').find_element(xPath: "//a[@href = 'trade/549/trade']")
  #   @buy_Platinum_Sydney = $browser.div(class: 'button is-danger').find_element(xPath: "//a[@href = 'trade/324/trade']")
  #   @sell_Platinum_Sydney = $browser.div(class: 'button is-success').find_element(xPath: "//a[@href = 'trade/324/trade']")
  #   @buy_Platinum_Zurich = $browser.div(class: 'button is-success').find_element(xPath: "//a[@href = 'trade/552/trade']")
  #   @sell_Platinum_Zurich = $browser.div(class: 'button is-danger').find_element(xPath: "//a[@href = 'trade/552/trade']")


  #   @dubai_hub = $browser.div(class: 'control').find_element(value: "32")
  #   @hongKong_hub = $browser.div(class: 'control').find_element(value: "23")
  #   @london_hub = $browser.div(class: 'control').find_element(value: "28")
  #   @newYork_hub = $browser.div(class: 'control').find_element(value: "27")
  #   @singapore_hub = $browser.div(class: 'control').find_element(value: "22")
  #   @syndey_hub = $browser.div(class: 'control').find_element(value: "25")
  #   @zurich_hub = $browser.div(class: 'control').find_element(value: "29")

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
