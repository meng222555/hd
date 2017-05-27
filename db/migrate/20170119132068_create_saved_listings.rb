class CreateSavedListings < ActiveRecord::Migration[5.0]
  def up
    create_table :saved_listings do |t|
      t.integer :user_id,              null: true
      t.integer :listing_id,           null: true
      
      t.timestamps
    end

    add_index :saved_listings, [:user_id, :listing_id],               unique: true
  end

  def down
    drop_table :saved_listings
  end
end
