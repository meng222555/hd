require 'rails_helper'

RSpec.feature "User login", :type => :feature do
  scenario "First time" do
    visit "/users/sign_in"

    # http://chrisestanol.com/blog/2016/03/12/introduction-to-testing-with-rspec/
    confirmed_user = FactoryGirl.create(:confirmed_user, email: 'genie@example.com', first_name: 'Tomas')

    # fill_in "Email", :with => "genie@example.com"
    find("input[placeholder='Email Address']").set confirmed_user.email
    find("input[placeholder='Password']").set confirmed_user.password
    
    click_button "Log in"

    expect(page).to have_text("My Profile")
    expect(page).to have_selector("input[value='genie@example.com']")
    expect(page).to have_selector("input[value='Tomas']")
  end

  scenario "Second time" do
    visit "/users/sign_in"

    # http://chrisestanol.com/blog/2016/03/12/introduction-to-testing-with-rspec/
    confirmed_user = FactoryGirl.create(:confirmed_user)

    # fill_in "Email", :with => "genie@example.com"
    find("input[placeholder='Email Address']").set confirmed_user.email
    find("input[placeholder='Password']").set confirmed_user.password
    
    click_button "Log in"
    click_link "Sign Out"
    # click_link "Sign In"
    first(:link, "Sign In").click

    find("input[placeholder='Email Address']").set confirmed_user.email
    find("input[placeholder='Password']").set confirmed_user.password
    
    click_button "Log in"

    expect(page).not_to have_text("My Profile")
    expect(page).to have_text("You have no listings")

  end
end
