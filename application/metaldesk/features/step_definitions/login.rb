Given('I login with username and password in the $user_data') do |user_data|
  user = YamlLoader.user_info(user_data)

  page_elements = LoginPage.new
  page_elements.set_username(user['username'])
  page_elements.set_password(user['password'])
  page_elements.submit_login

  Watir::Wait.until(timeout: 10) { $browser.text.downcase.include? 'trade' }

  puts "Logged in successfully as #{user['username']}"
end

Then('I logout from MetalDesk') do
  page_elements = LoginPage.new
  page_elements.submit_logout
end

Then('I exit the browser') do
  $browser.quit
end
