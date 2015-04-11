require 'rails_helper'

describe 'User can CRUD projects' do

  before(:each) do
    @user = User.create(first_name: 'first', last_name: 'last', email: 'firstlast@email.com', password: 'pass')
    visit '/sign-in'
    fill_in 'email', :with => 'firstlast@email.com'
    fill_in 'password', :with => 'pass'
    click_button "Sign In"
  end

  scenario 'User can create a project' do

    visit '/projects'

    page.find("#new-project-button").click

    fill_in 'project_name', :with => "Awesome Project"

    click_on "Create Project"

    expect(page).to have_content("Project was successfully created.")
    expect(page).to have_content("Awesome Project")
  end

  scenario 'User can view a show page for a project' do
    @project = Project.create(name: "Cool Project")
    Membership.create(project_id: @project.id, user_id: @user.id)
    visit "/projects/#{@project.id}"

    expect(page).to have_content @project.name
  end

  scenario 'User can edit a project' do
    @project = Project.create(name: "Cool Project")
    Membership.create(project_id: @project.id, user_id: @user.id, role: 1)

    visit "/projects/#{@project.id}/edit"

    fill_in 'project_name', :with => "Awesome Project"

    click_on "Update Project"
    expect(page).to have_content("Project was successfully updated.")
    expect(page).to have_content("Awesome Project")
  end

  scenario 'User can delete a task' do
    @project = Project.create(name: "Cool Project")
    Membership.create(project_id: @project.id, user_id: @user.id, role: 1)

    visit "/projects/#{@project.id}"

    click_on "Delete"
    expect(page).to have_content("Project was successfully destroyed.")
  end

end
