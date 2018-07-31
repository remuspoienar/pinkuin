Given('I have created several projects') do
  @projects = FactoryBot.create_list(:project, 2, author: @registered_user)
end

Then('I should see the list of my projects') do
  expect(page).to have_content(@projects[0].name)
  expect(page).to have_content(@projects[1].name)
end

Given('I have the right to create projects') do
  @registered_user.add_role(:create, Project)
end

When("I fill in the project's details") do
  @project = FactoryBot.build(:project)

  fill_in 'project_name', with: @project.name
  fill_in 'project_description', with: @project.description
  select Project::STATUS_ACTIVE, from: 'project_status'
end

Then('I should see that my project was saved') do
  expect(page).to have_content('PROJECT DETAILS')
  expect(page).to have_content(@project.name)
  expect(page).to have_content(@project.description)
  expect(page).to have_content(@registered_user.username) # equal to @project.author.username
  expect(page).to have_content(@project.status)
end

Given("I have previously created a project") do
  @old_project = FactoryBot.create(:project, author: @registered_user)
end

When("I go to the project's page") do
  visit project_path(@old_project)
end

Then("I should not see it in the projects list anymore") do
  expect(page).to have_content('Project was successfully deleted.')
  expect(page).to_not have_content(@old_project.name)
end
