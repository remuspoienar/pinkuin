user_data = FactoryBot.attributes_for(:user)
username  = user_data[:username]
email     = user_data[:email]
password  = user_data[:password]

Given('I visit the homepage') do
  visit root_path
end

When('I fill in the sign up form') do
  click_link 'Sign up'

  fill_in 'user_email', with: email
  fill_in 'user_username', with: username
  fill_in 'user_password', with: password
  fill_in 'user_password_confirmation', with: password

  click_button 'Sign up'
end

When('I confirm the email') do
  open_email(email)

  visit_in_email('Confirm my account')
end

Then('I should see that my account is confirmed') do
  message = 'Your email address has been successfully confirmed'

  expect(page).to have_content(message)
end


Given('I am a registered user') do
  @registered_user = FactoryBot.create(:user, username: username, email: email, password: password)
end

When('I fill in the login form') do
  fill_in 'user_email', with: email
  fill_in 'user_password', with: password

  click_button 'Log in'
end

Then('I should be logged in') do
  expect(page).to have_content('All projects')
end


Given('I am logged in') do
  visit root_path

  fill_in 'user_email', with: email
  fill_in 'user_password', with: password

  click_button 'Log in'
end

When('I click on the log out button') do
  click_link 'Log out'
end

Then('I should be redirected to the log in page') do
  expect(page).to have_content('Log in')
end
