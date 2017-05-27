class CreateLookupTenure < ActiveRecord::Migration[5.0]
  def up
    create_table :tenures, id: false do |t|
      t.integer :id,              null: false
      t.string :description,              null: false, default: ""
      t.integer :property_type_id,              null: false
    end

    execute <<-SQL
      ALTER TABLE tenures ADD PRIMARY KEY (id);

      INSERT INTO tenures ( id, description, property_type_id) VALUES 
        ( 1, '99 Years Leasehold (HDB)', 1),
        ( 2, '99 Years Leasehold (Condo/Apt)', 2),
        ( 3, '99 Years Leasehold (Landed Property)', 3),
        ( 4, 'Freehold/999 Years (Condo/Apt)', 2),
        ( 5, 'Freehold/999 Years (Landed Property)', 3);
    SQL

    

  end

  def down
    drop_table :tenures
  end


end
