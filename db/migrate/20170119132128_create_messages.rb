class CreateMessages < ActiveRecord::Migration[5.0]
  def change
    create_table :messages do |t|
      t.integer :user_id,              null: true
      t.integer :listing_id,           null: true
      
      t.timestamps null: false
    end
  end

  # def down
  #   drop_table :listings
  # end
end
