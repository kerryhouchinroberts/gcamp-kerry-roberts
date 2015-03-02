require 'rails_helper'

describe 'User can sign up with valid information' do

  scenario 'User can sign up for gCamp' do

    visit '/sign-up'

    fill_in 'user_first_name', :with => "Chewbacca"
    fill_in 'user_last_name', :with => "Wookie"
    fill_in 'user_email', :with => "chewy@theforce.com"
    fill_in 'user_password', :with => "r2d2"
    fill_in 'user_password_confirmation', :with => "r2d2"

    click_button "Sign Up"

    expect(page).to have_content("Chewbacca Wookie")
  end

  scenario 'User cannot sign up without valid first name' do

    visit '/sign-up'

    fill_in 'user_first_name', :with => ""
    fill_in 'user_last_name', :with => "Wookie"
    fill_in 'user_email', :with => "chewy@theforce.com"
    fill_in 'user_password', :with => "r2d2"
    fill_in 'user_password_confirmation', :with => "r2d2"

    click_button "Sign Up"

    expect(page).to have_content("First name can't be blank")
  end

  scenario 'User cannot sign up without valid first name' do

    visit '/sign-up'

    fill_in 'user_first_name', :with => "Chewbacca"
    fill_in 'user_last_name', :with => ""
    fill_in 'user_email', :with => "chewy@theforce.com"
    fill_in 'user_password', :with => "r2d2"
    fill_in 'user_password_confirmation', :with => "r2d2"

    click_button "Sign Up"

    expect(page).to have_content("Last name can't be blank")
  end

  scenario 'User cannot sign up without valid email' do

    visit '/sign-up'

    fill_in 'user_first_name', :with => "Chewbacca"
    fill_in 'user_last_name', :with => "Wookie"
    fill_in 'user_email', :with => ""
    fill_in 'user_password', :with => "r2d2"
    fill_in 'user_password_confirmation', :with => "r2d2"

    click_button "Sign Up"

    expect(page).to have_content("Email can't be blank")
  end

  scenario 'User cannot sign up without password' do

    visit '/sign-up'

    fill_in 'user_first_name', :with => "Chewbacca"
    fill_in 'user_last_name', :with => "Wookie"
    fill_in 'user_email', :with => "chewy@theforce.com"
    fill_in 'user_password', :with => ""
    fill_in 'user_password_confirmation', :with => "r2d2"

    click_button "Sign Up"

    expect(page).to have_content("Password can't be blank")
  end

  scenario 'User cannot sign up without matching passwords' do

    visit '/sign-up'

    fill_in 'user_first_name', :with => "Chewbacca"
    fill_in 'user_last_name', :with => "Wookie"
    fill_in 'user_email', :with => "chewy@theforce.com"
    fill_in 'user_password', :with => "r2d2"
    fill_in 'user_password_confirmation', :with => "r3d2"

    click_button "Sign Up"

    expect(page).to have_content("Password confirmation doesn't match Password")
  end

end
