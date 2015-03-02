require 'rails_helper'

describe 'Logged in user can sign out' do

  before(:each) do
    User.create(first_name: 'first', last_name: 'last', email: 'firstlast@email.com', password: 'pass')
    visit '/sign-in'
    fill_in 'email', :with => 'firstlast@email.com'
    fill_in 'password', :with => 'pass'
    click_button "Sign In"
  end

  scenario 'User can sign out' do

    visit '/'

    click_on 'Sign Out'

    expect(page).to have_content("Sign In")
  end
end
