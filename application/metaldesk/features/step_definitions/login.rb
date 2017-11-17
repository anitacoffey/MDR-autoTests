Given('I login with username and password in the $user_data') do |user_data|
  user = YamlLoader.user_info(user_data)

  login_page = LoginPage.new
  login_page.set_username(user['username'])
  login_page.set_password(user['password'])
  login_page.submit_login

  Watir::Wait.until(timeout: 10) { $browser.text.downcase.include? 'trade' }

  puts "Logged in successfully as #{user['username']}"
end

Then('I logout from MetalDesk') do
  login_page = LoginPage.new
  login_page.submit_logout
end

Then('I exit the browser') do
  $browser.quit
end
