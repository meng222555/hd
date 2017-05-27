class CreateListings < ActiveRecord::Migration[5.0]
  def up
    create_table :listings do |t|
      t.integer :user_id,              null: true

      # LISTING TYPE
      t.string :listing_type,              null: false, default: "" # 'FOR SALE', 'FOR RENT'
      t.string :rental_type, :limit => 25, null: true # 'Whole Unit', 'Room Only'
      # lookups
      t.integer :property_type_id,              null: true # description 'HDB', Condominium/Apartment', 'Landed Property'
      t.integer :property_sub_type_id,              null: true # depends on property_type
      t.integer :tenure_id,              null: true # applys only to listing_type 'FOR SALE', depends on property_type

      # LOCATION
      t.integer :district_id,         null: true # lookup, applys only to property_type 'Condominium/Apartment', 'Landed Property'
      t.integer :estate_id,           null: true # lookup, applys only to property_type 'HDB'
      t.string :district_or_estate, :limit => 1, null: true # 'd' district, 'e' estate
      t.string :address, :limit => 255, null: true
      t.string :postal_code, :limit => 15, null: true
      t.string :floor, :limit => 15, null: true
      t.string :unit_no, :limit => 15, null: true
      t.integer :show_unit,              null: false, default: 0 # 0 false
      # ... kiv google maps ...

      # DETAILS
      t.decimal :size_area, precision: 10, scale: 2,    null: true
      t.string :size_unit,              null: true # SQFT or SQM
      t.decimal :size_sqm, precision: 10, scale: 2,    null: true
      t.decimal :size_sqft, precision: 10, scale: 2,    null: true
      t.string :bedrooms,               null: true # 1..10 cf dropdown 1 to 10+
      t.string :bathrooms,              null: true # 1..10 cf dropdown 1 to 10+
      t.string :furnishing, :limit => 25, null: true # 'Unfurnished', 'Partially Furnished', 'Fully Furnished'
      t.string :floor_type, :limit => 25, null: true # 'Ground', 'Low', 'Middle', 'High', 'Penthouse'
      # ... kiv features ...

      # MEDIA
      # ... kiv photos PaperClips ...

      # DESCRIPTION
      t.string :description, :limit => 2000,            null: true
      t.string :listing_name, :limit => 40, null: true, default: "" # This is the headline of your listing. (max. 40 charaters)
      t.decimal :asking_price, precision: 10, scale: 2,    null: true

      t.string :lat, :limit => 30, null: true
      t.string :lng, :limit => 30, null: true

      t.string :status,              null: false, default: "" # 'FOR SALE', 'FOR RENT', 'SOLD', 'RENTED'
      t.integer :published,              null: false, default: 0 # 0 false
      t.timestamps null: false
    end
  end

  def down
    drop_table :listings
  end
end
