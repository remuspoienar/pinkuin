# =Shared steps

When("I click the delete button and confirm") do
  accept_confirm do
    click_button 'Delete'
  end
end

When(/I click on the ([\w ]+) button$/) do |link_or_btn_name|
  click_link_or_button link_or_btn_name
end

Given('I visit the homepage') do
  visit root_path
end

Given('I am logged in') do
  visit root_path

  fill_in 'user_email', with: @registered_user.email
  fill_in 'user_password', with: @registered_user.password

  click_button 'Log in'
end

# Shared steps=