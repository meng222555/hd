class CreatePhotos < ActiveRecord::Migration[5.0]
  def change
    create_table :photos do |t|
      t.integer :listing_id
      t.integer :seq

      t.timestamps
    end
  end
end
