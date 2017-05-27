class CreateListingsSceneries < ActiveRecord::Migration
  def up

    create_table :listings_sceneries, :id => false do |t|
      t.integer :listing_id
      t.integer :scenery_id
    end
    
  end

  def down
    # drop_table :listings_sceneries
    execute "DROP TABLE IF EXISTS listings_sceneries;"
  end

end
