require 'factory_girl_rails'

Listing.delete_all

9.times do
  FactoryGirl.create :listing
end
