Given('I have created several projects') do
  @projects = FactoryBot.create_list(:project, 2, author: @registered_user)
end

Then('I should see the list of my projects') do
  expect(page).to have_content(@projects[0].name)
  expect(page).to have_content(@projects[1].name)
end
