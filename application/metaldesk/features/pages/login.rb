class LoginPage
  def initialize
    @username_field = $browser.forms(class: 'bc-form')[1].fieldset.text_field(index: 0)
    @password_field = $browser.forms(class: 'bc-form')[1].fieldset.text_field(index: 1)
    @login_button = $browser.forms(class: 'bc-form')[1].nav.button(type: 'submit')
    @logout_button = $browser.link(id: 'nav-panel-8')
  end

  def insert_username(username)
    @username_field.set(username)
  end

  def insert_password(password)
    @password_field.set(password)
  end

  def submit_login
    @login_button.click
  end

  def submit_logout
    @logout_button.click
  end
end
