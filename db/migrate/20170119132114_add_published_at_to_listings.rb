class AddPublishedAtToListings < ActiveRecord::Migration[5.0]
  def change
    change_table :listings do |t|
      t.datetime :published_at
    end
  end
end
