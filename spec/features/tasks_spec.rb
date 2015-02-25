require 'rails_helper'


describe 'User can CRUD tasks' do

  before(:each) do
    User.create(first_name: 'first', last_name: 'last', email: 'firstlast@email.com', password: 'pass')
    visit '/sign-in'
    fill_in 'email', :with => 'firstlast@email.com'
    fill_in 'password', :with => 'pass'
    click_button "Sign In"
  end
  
  scenario 'User can create a task' do

    visit '/tasks'

    click_on "New Task"

    fill_in 'task_description', :with => "Awesome Task"
    select '2014', :from => "task_due_date_1i"
    select 'June', :from => "task_due_date_2i"
    select '11', :from => "task_due_date_3i"

    click_on "Create Task"

    expect(page).to have_content("Task was successfully created.")
    expect(page).to have_content("Awesome Task")
  end

  scenario 'User can view a show page for a task' do
    @task = Task.create(description: "Cool Task", due_date: "2015-02-18")

    visit "tasks/#{@task.id}"

    expect(page).to have_content @task.description
  end

  scenario 'User can edit a task' do
    @task = Task.create(description: "Cool Task", due_date: "2015-02-18")

    visit "tasks/#{@task.id}/edit"

    fill_in 'task_description', :with => "Awesome Task"
    select '2014', :from => "task_due_date_1i"
    select 'June', :from => "task_due_date_2i"
    select '11', :from => "task_due_date_3i"

    click_on "Update Task"

    expect(page).to have_content("Task was successfully updated.")
    expect(page).to have_content("Awesome Task")
  end

  scenario 'User can delete a task' do
    @task = Task.create(description: "Cool Task", due_date: "2015-02-18")

    visit "/tasks"

    click_on "Delete"
    expect(page).to have_content("Task was successfully destroyed.")
  end

end
