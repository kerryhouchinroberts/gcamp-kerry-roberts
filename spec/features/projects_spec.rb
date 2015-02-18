require 'rails_helper'


describe 'User can CRUD projects' do

  scenario 'User can create a project' do

    visit '/projects'

    click_on "New Project"

    fill_in 'project_name', :with => "Awesome Project"

    click_on "Create Project"

    expect(page).to have_content("Project was successfully created.")
    expect(page).to have_content("Awesome Project")
  end

  scenario 'User can view a show page for a project' do
    @project = Project.create(name: "Cool Project")
    visit "/projects/#{@project.id}"

    expect(page).to have_content @project.name
  end

  scenario 'User can edit a project' do
    @project = Project.create(name: "Cool Project")

    visit "/projects/#{@project.id}/edit"

    fill_in 'project_name', :with => "Awesome Project"

    click_on "Update Project"
    expect(page).to have_content("Project was successfully updated.")
    expect(page).to have_content("Awesome Project")
  end

  scenario 'User can delete a task' do
    @project = Project.create(name: "Cool Project")

    visit "/projects/#{@project.id}"

    click_on "Delete"
    expect(page).to have_content("Project was successfully destroyed.")
  end

end
