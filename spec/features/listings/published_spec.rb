require 'rails_helper'

RSpec.feature "Published Listings", :type => :feature do
  scenario "Volume doesn't exceed Kaminari default_per_page" do
    Kaminari.config.default_per_page.times do
      FactoryGirl.create(:published_listing)
    end

    visit "/listings"

    expect(page).not_to have_text("Prev")
    expect(page).not_to have_text("Next")
  end

  scenario "Volume exceeds Kaminari default_per_page" do
    Kaminari.config.default_per_page.times do
      FactoryGirl.create(:published_listing)
    end

    FactoryGirl.create(:published_listing)

    visit "/listings"

    expect(page).to have_text("Prev")
    expect(page).to have_text("Next")
  end
end
