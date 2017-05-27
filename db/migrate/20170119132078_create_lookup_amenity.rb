class CreateLookupAmenity < ActiveRecord::Migration[5.0]
  def up
    create_table :amenities, id: false do |t|
      t.integer :id,                       null: false
      t.string :description,              null: false, default: ""
    end

    execute <<-SQL
      ALTER TABLE amenities ADD PRIMARY KEY (id);

      INSERT INTO amenities ( id, description) VALUES 
        ( 1, 'BBQ Pits'),
        ( 2, 'Badminton Court'),
        ( 3, 'Basketball Court'),
        ( 4, 'Club House'),
        ( 5, 'Function Room'),
        ( 6, 'Gym'),
        ( 7, 'Jacuzzi'),
        ( 8, 'Lap Pool'),
        ( 9, 'Mini-Mart'),
        ( 10, 'Playground'),
        ( 11, 'Tennis Court'),
        ( 12, 'Wading Pool');
    SQL

    add_index :amenities, :description,                unique: true

  end

  def down
    drop_table :amenities
  end


end
