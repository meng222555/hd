# https://www.sitepoint.com/learn-the-first-best-practices-for-rails-and-rspec/
RSpec.configure do |config|

  module DatabaseCleaner
    def self.lookup_tables_not_to_trunc
      %w[amenities asking_prices bathrooms bedrooms districts estates features property_sub_types property_types sceneries sqft_size_areas tenures]
    end
  end 

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation, :except => DatabaseCleaner.lookup_tables_not_to_trunc)
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, :js => true) do
    DatabaseCleaner.strategy = :truncation, { :except => DatabaseCleaner.lookup_tables_not_to_trunc}
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end
