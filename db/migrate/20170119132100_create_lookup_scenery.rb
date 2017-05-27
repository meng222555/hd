class CreateLookupScenery < ActiveRecord::Migration[5.0]
  def up
    create_table :sceneries, id: false do |t|
      t.integer :id,                       null: false
      t.string :description,              null: false, default: ""
    end

    execute <<-SQL
      ALTER TABLE sceneries ADD PRIMARY KEY (id);
      INSERT INTO sceneries ( id, description) VALUES 
        ( 1, 'City View'),
        ( 2, 'Greenery View'),
        ( 3, 'Panoramic View'),
        ( 4, 'Pool View'),
        ( 5, 'Reservoir View'),
        ( 6, 'Sea View');
    SQL

    add_index :sceneries, :description,                unique: true

  end

  def down
    drop_table :sceneries
  end


end
