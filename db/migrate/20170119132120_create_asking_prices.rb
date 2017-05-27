class CreateAskingPrices < ActiveRecord::Migration[5.0]
  def up
    create_table :asking_prices, id: false do |t|
      t.string :id,              null: false, default: ""
      t.string :description,              null: false, default: ""
      t.string :listing_type,              null: false, default: ""
    end

    execute <<-SQL
      ALTER TABLE asking_prices ADD PRIMARY KEY (id);

      INSERT INTO asking_prices ( id, description, listing_type) VALUES 
        ( '500000', 'less than $500,000', 'FOR SALE'),
        ( '1000000', 'less than $1,000,000', 'FOR SALE'),
        ( '1500000', 'less than $1,500,000', 'FOR SALE'),
        ( '2000000', 'less than $2,000,000', 'FOR SALE'),
        ( '2500000', 'less than $2,500,000', 'FOR SALE'),
        ( '3000000', 'less than $3,000,000', 'FOR SALE'),
        ( '3500000', 'less than $3,500,000', 'FOR SALE'),
        ( '4000000', 'less than $4,000,000', 'FOR SALE'),
        ( '4500000', 'less than $4,500,000', 'FOR SALE'),
        ( '5000000', 'less than $5,000,000', 'FOR SALE'),
        ( '5000000+', '$5,000,000 or more', 'FOR SALE'),
        ( '500', 'less than $500', 'FOR RENT'),
        ( '1000', 'less than $1,000', 'FOR RENT'),
        ( '1500', 'less than $1,500', 'FOR RENT'),
        ( '2000', 'less than $2,000', 'FOR RENT'),
        ( '2500', 'less than $2,500', 'FOR RENT'),
        ( '3000', 'less than $3,000', 'FOR RENT'),
        ( '3500', 'less than $3,500', 'FOR RENT'),
        ( '4000', 'less than $4,000', 'FOR RENT'),
        ( '5000', 'less than $5,000', 'FOR RENT'),
        ( '6000', 'less than $6,000', 'FOR RENT'),
        ( '7000', 'less than $7,000', 'FOR RENT'),
        ( '8000', 'less than $8,000', 'FOR RENT'),
        ( '9000', 'less than $9,000', 'FOR RENT'),
        ( '10000', 'less than $10,000', 'FOR RENT'),
        ( '12000', 'less than $12,000', 'FOR RENT'),
        ( '15000', 'less than $15,000', 'FOR RENT'),
        ( '20000', 'less than $20,000', 'FOR RENT'),
        ( '20000+', '$20,000 or more', 'FOR RENT');

    SQL

  end

  def down
    drop_table :asking_prices
  end
end
