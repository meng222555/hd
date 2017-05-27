class CreateFeaturesListings < ActiveRecord::Migration
  def change
    
    execute "DROP TABLE IF EXISTS features_listings;"
    
    create_table :features_listings, :id => false do |t|
      t.integer :feature_id
      t.integer :listing_id
    end
    
  end
end
