class AddCoverIdToListings < ActiveRecord::Migration[5.0]
  def change
    change_table :listings do |t|
      t.integer :cover_id
    end
  end
end
