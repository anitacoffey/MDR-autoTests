class LoginPage
  def initialize
    @username_field = $browser.divs(class: 'field')[0].input(name: 'username')
    @password_field = $browser.divs(class: 'field')[1].input(name: 'password')
    @login_button = $browser.divs(class: 'field')[3].buttons(type: 'submit')[0]
  end

  def insert_username(username)
    @username_field.click()
    @username_field.send_keys(username)
  end

  def insert_password(password)
    @password_field.click()
    @password_field.send_keys(password)
  end

  def submit_login
    @login_button.click
  end

  def submit_logout
    @logout_button.click
  end
end
