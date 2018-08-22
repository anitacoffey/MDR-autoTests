class NavigationPage
  def initialize
    @liquidity_page = $browser.div(id: 'views').nav(id: 'sidebar-menu').a(index: 1)
  end

  def to_liquidity_page
    @liquidity_page.click
  end
end
