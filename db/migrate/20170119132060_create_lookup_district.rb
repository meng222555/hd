class CreateLookupDistrict < ActiveRecord::Migration[5.0]
  def up
    create_table :districts, id: false do |t|
      t.integer :id,              null: false
      t.string :description,              null: false, default: ""
    end

    execute <<-SQL
      ALTER TABLE districts ADD PRIMARY KEY (id);

      INSERT INTO districts ( id, description) VALUES 
        ( 1, 'D01 Boat Quay / Raffles Place / Marina'),
        ( 2, 'D02 Chinatown / Tanjong Pagar'),
        ( 3, 'D03 Alexandra / Commonwealth'),
        ( 4, 'D04 Harbourfront / Telok Blangah'),
        ( 5, 'D05 Buona Vista / West Coast / Clementi New Town'),
        ( 6, 'D06 City Hall / Clarke Quay'),
        ( 7, 'D07 Beach Road / Bugis / Rochor'),
        ( 8, 'D08 Farrer Park / Serangoon Rd'),
        ( 9, 'D09 Orchard / River Valley'),
        ( 10, 'D10 Tanglin / Holland'),
        ( 11, 'D11 Newton / Novena'),
        ( 12, 'D12 Balestier / Toa Payoh'),
        ( 13, 'D13 Macpherson / Potong Pasir'),
        ( 14, 'D14 Eunos / Geylang / Paya Lebar'),
        ( 15, 'D15 East Coast / Marine Parade'),
        ( 16, 'D16 Bedok / Upper East Coast'),
        ( 17, 'D17 Changi Airport / Changi Village'),
        ( 18, 'D18 Pasir Ris / Tampines'),
        ( 19, 'D19 Hougang / Punggol / Sengkang'),
        ( 20, 'D20 Ang Mo Kio / Bishan / Thomson'),
        ( 21, 'D21 Clementi Park / Upper Bukit Timah'),
        ( 22, 'D22 Boon Lay / Jurong / Tuas'),
        ( 23, 'D23 Bukit Batok / Bukit Panjang'),
        ( 24, 'D24 Choa Chu Kang / Tengah'),
        ( 25, 'D25 Admiralty / Woodlands'),
        ( 26, 'D26 Mandai / Upper Thomson'),
        ( 27, 'D27 Sembawang / Yishun'),
        ( 28, 'D28 Seletar / Yio Chu Kang');
    SQL

    # add_index :districts, :id,                unique: true

  end

  def down
    drop_table :districts
  end


end
