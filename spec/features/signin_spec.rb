require 'rails_helper'

describe 'User can sign in with valid information' do

  scenario 'User can sign in' do
    @user = User.create(first_name: "Kerry", last_name: "Roberts", email: "kerry@roberts.com", password: "test")

    visit '/sign-in'

    fill_in 'email', :with => "kerry@roberts.com"
    fill_in 'password', :with => "test"

    click_button "Sign In"

    expect(page).to have_content("Kerry Roberts")

  end

  scenario 'User cannot sign in without email' do
    @user = User.create(first_name: "Kerry", last_name: "Roberts", email: "kerry@roberts.com", password: "test")

    visit '/sign-in'

    fill_in 'email', :with => ""
    fill_in 'password', :with => "test"

    click_button "Sign In"

    expect(page).to have_content("Username / password combination is invalid")

  end

  scenario 'User cannot sign in without password' do
    @user = User.create(first_name: "Kerry", last_name: "Roberts", email: "kerry@roberts.com", password: "test")

    visit '/sign-in'

    fill_in 'email', :with => "kerry@roberts.com"
    fill_in 'password', :with => ""

    click_button "Sign In"

    expect(page).to have_content("Username / password combination is invalid")

  end

  scenario 'User cannot sign in with invalid password' do
    @user = User.create(first_name: "Kerry", last_name: "Roberts", email: "kerry@roberts.com", password: "test")

    visit '/sign-in'

    fill_in 'email', :with => "kerry@roberts.com"
    fill_in 'password', :with => "password"

    click_button "Sign In"

    expect(page).to have_content("Username / password combination is invalid")

  end
end
