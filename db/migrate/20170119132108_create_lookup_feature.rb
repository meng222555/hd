class CreateLookupFeature < ActiveRecord::Migration[5.0]
  def up
    create_table :features, id: false do |t|
      t.integer :id,                       null: false
      t.string :description,              null: false, default: ""
    end

    execute <<-SQL
      ALTER TABLE features ADD PRIMARY KEY (id);

      INSERT INTO features ( id, description) VALUES 
        ( 1, 'Air Conditioning'),
        ( 2, 'Balcony'),
        ( 3, 'Bay Window'),
        ( 4, 'Corner Unit'),
        ( 5, 'Maid''s Bath'),
        ( 6, 'Maid''s Room'),
        ( 7, 'Original Condition'),
        ( 8, 'Outdoor Patio'),
        ( 9, 'Powder Room'),
        ( 10, 'Private Garden'),
        ( 11, 'Private Pool'),
        ( 12, 'Renovated'),
        ( 13, 'Roof Terrace'),
        ( 14, 'Study Room'),
        ( 15, 'Walk-In-Wardrobe');

    SQL

    add_index :features, :description,                unique: true

  end

  def down
    drop_table :features
  end


end
