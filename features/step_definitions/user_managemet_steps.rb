Before('@create_users') do
  @users = FactoryBot.create_list(:user, 3)
end

When('I visit the User Administration page') do
  visit admin_users_path
end

Given('I have the general role to administrate users') do
  @registered_user.add_role(:admin, User)
end

Then('I should see the list of registered users') do
  expect(page).to have_content(@users[0].email)
  expect(page).to have_content(@users[1].email)
  expect(page).to have_content(@users[2].email)
end

Given('I have the right to create users') do
  @registered_user.add_role(:create, User)
end

When("I fill in the user's details") do
  @user_data = FactoryBot.attributes_for(:user)

  fill_in 'user_email', with: @user_data[:email]
  fill_in 'user_username', with: @user_data[:username]
  fill_in 'user_password', with: @user_data[:password]
  fill_in 'user_password_confirmation', with: @user_data[:password]
end

Then(/I should see that the user was (.*)/) do |created_or_updated|
  expect(page).to have_content("User was successfully #{created_or_updated}.")
  expect(page).to have_content('USER DETAILS')
  expect(page).to have_content(@user_data[:email])
  expect(page).to have_content(@user_data[:username])
end

Given('I have previously created an user') do
  @user = FactoryBot.create(:user)
  @registered_user.add_role(:admin, @user)
end

When("I go to that user's page") do
  visit admin_user_path(@user)
end

Then('I should not see it in the users list anymore') do
  expect(page).to have_content('User was successfully deleted.')
  expect(page).to_not have_content(@user.email)
end
