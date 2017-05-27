class CreateSqftSizeAreas < ActiveRecord::Migration[5.0]
  def up
    create_table :sqft_size_areas, id: false do |t|
      t.string :id,              null: false, default: ""
      t.string :description,              null: false, default: ""
    end

    execute <<-SQL
      ALTER TABLE sqft_size_areas ADD PRIMARY KEY (id);

      INSERT INTO sqft_size_areas ( id, description) VALUES 
        ( '500', 'less than 500 sqft (46 sqm)'),
        ( '750', 'less than 750 sqft (70 sqm)'),
        ( '1000', 'less than 1000 sqft (93 sqm)'),
        ( '1200', 'less than 1200 sqft (112 sqm)'),
        ( '1500', 'less than 1500 sqft (139 sqm)'),
        ( '2000', 'less than 2000 sqft (186 sqm)'),
        ( '2500', 'less than 2500 sqft (232 sqm)'),
        ( '3000', 'less than 3000 sqft (279 sqm)'),
        ( '4000', 'less than 4000 sqft (372 sqm)'),
        ( '5000', 'less than 5000 sqft (465 sqm)'),
        ( '5000+', '5000 sqft (465 sqm) or more');

    SQL

  end

  def down
    drop_table :sqft_size_areas
  end
end
