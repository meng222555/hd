class CreateAmenitiesListings < ActiveRecord::Migration
  def change
    
    execute "DROP TABLE IF EXISTS amenities_listings;"
    
    create_table :amenities_listings, :id => false do |t|
      t.integer :amenity_id
      t.integer :listing_id
    end
    
  end
end
