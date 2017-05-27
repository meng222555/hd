class CreateLookupPropertySubType < ActiveRecord::Migration[5.0]
  def up
    create_table :property_sub_types, id: false do |t|
      t.integer :id,              null: false
      t.string :description,              null: false, default: ""
      t.integer :property_type_id,              null: false
    end

    execute <<-SQL
      ALTER TABLE property_sub_types ADD PRIMARY KEY (id);

      INSERT INTO property_sub_types ( id, description, property_type_id) VALUES 
        ( 1, 'Condominium', 2),  
        ( 2, 'Apartment', 2), 
        ( 3, 'Walk-Up', 2), 
        ( 4, 'Cluster House', 2), 
        ( 5, 'Executive Condominium', 2), 
        ( 6, 'Terraced House', 3), 
        ( 7, 'Detached House', 3), 
        ( 8, 'Semi-Detached House', 3), 
        ( 9, 'Corner Terrace', 3), 
        ( 10, 'Bungalow House', 3), 
        ( 11, 'Good Class Bungalow', 3), 
        ( 12, 'Shophouse', 3), 
        ( 13, 'Land Only', 3), 
        ( 14, 'Town House', 3), 
        ( 15, 'Conservation House', 3), 
        ( 16, 'Cluster House', 3), 
        ( 17, '1-room studio ', 1), 
        ( 18, '2-room flat ', 1), 
        ( 19, '3-room flat ', 1), 
        ( 20, '4-room flat ', 1), 
        ( 21, '5-room flat ', 1), 
        ( 22, 'Jumbo ', 1), 
        ( 23, 'Executive Apartment ', 1), 
        ( 24, 'Executive Maisonette ', 1), 
        ( 25, 'Multi-Generation ', 1), 
        ( 26, 'Terrace ', 1), 
        ( 28, 'Adjoined Flat ', 1), 
        ( 29, 'Model A Maisonette ', 1);

    SQL

  end

  def down
    drop_table :property_sub_types
  end
end
