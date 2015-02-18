require 'rails_helper'


describe 'User can CRUD users' do

  scenario 'User can create a user' do

    visit '/users'

    click_on "New User"

    fill_in 'user_first_name', :with => "Kerry"
    fill_in 'user_last_name', :with => "Roberts"
    fill_in 'user_email', :with => "email@example.com"

    click_on "Create User"

    expect(page).to have_content("User was successfully created.")
    expect(page).to have_content("Roberts")
  end


    scenario 'User can view a show page for a user' do
      @user = User.create(first_name: "Cool", last_name: "dude", email: "cooldude@aol.com")

      visit "/users/#{@user.id}"

      expect(page).to have_content @user.first_name
      expect(page).to have_content @user.last_name
    end

    scenario 'User can edit a user' do
      @user = User.create(first_name: "Cool", last_name: "dude", email: "cooldude@aol.com")

      visit "/users/#{@user.id}/edit"

      fill_in 'user_first_name', :with => "Kerry"
      fill_in 'user_last_name', :with => "Roberts"
      fill_in 'user_email', :with => "email@example.com"

      click_on "Update User"

      expect(page).to have_content("User was successfully edited.")
      expect(page).to have_content("Kerry")
    end

    scenario 'User can delete a user from the edit page' do
      @user = User.create(first_name: "Cool", last_name: "dude", email: "cooldude@aol.com")

      visit "/users/#{@user.id}/edit"

      click_on "Delete User"

      expect(page).to have_content("User was successfully destroyed.")
    end

    scenario 'User can delete a user from the users index' do
      @user = User.create(first_name: "Cool", last_name: "dude", email: "cooldude@aol.com")

      visit "/users"

      click_on "Delete"

      expect(page).to have_content("User was successfully destroyed.")
    end
end
