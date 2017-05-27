class CreateLookupPropertyType < ActiveRecord::Migration[5.0]
  def up
    create_table :property_types, id: false do |t|
      t.integer :id,              null: false
      t.string :description,              null: false, default: ""
    end

    execute <<-SQL
      ALTER TABLE property_types ADD PRIMARY KEY (id);

      INSERT INTO property_types ( id, description) VALUES 
        ( 1, 'HDB'),
        ( 2, 'Condominium/Apartment'),
        ( 3, 'Landed Property');
    SQL

  end

  def down
    drop_table :property_types
  end
end
