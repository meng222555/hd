class CreateLookupBathroom < ActiveRecord::Migration[5.0]
  def up
    create_table :bathrooms, id: false do |t|
      t.string :id,                       null: false, default: ""
      t.string :description,              null: false, default: ""
    end

    execute <<-SQL
      ALTER TABLE bathrooms ADD PRIMARY KEY (id);

      INSERT INTO bathrooms ( id, description) VALUES 
        ( '1', '1'),
        ( '2', '2'),
        ( '3', '3'),
        ( '4', '4'),
        ( '5', '5'),
        ( '6', '6'),
        ( '7', '7'),
        ( '8', '8'),
        ( '9', '9'),
        ( '10', '10'),
        ( '10+', '10+');
    SQL

    # add_index :bathrooms, :id,                unique: true

  end

  def down
    drop_table :bathrooms
  end


end
