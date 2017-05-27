class CreateLookupEstate < ActiveRecord::Migration[5.0]
  def up
    create_table :estates, id: false do |t|
      t.integer :id,              null: false
      t.string :description,              null: false, default: ""
    end

    execute <<-SQL
      ALTER TABLE estates ADD PRIMARY KEY (id);

      INSERT INTO estates ( id, description) VALUES 
        ( 1, 'Ang Mo Kio'),
        ( 2, 'Bedok'),
        ( 3, 'Bishan'),
        ( 4, 'Bukit Batok'),
        ( 5, 'Bukit Merah'),
        ( 6, 'Bukit Panjang'),
        ( 7, 'Bukit Timah'),
        ( 8, 'Central Area'),
        ( 9, 'Choa Chu Kang'),
        ( 10, 'Clementi'),
        ( 11, 'Geylang'),
        ( 12, 'Hougang'),
        ( 13, 'Jurong East'),
        ( 14, 'Jurong West'),
        ( 15, 'Kallang/Whampoa'),
        ( 16, 'Lim Chu Kang'),
        ( 17, 'Marine Parade'),
        ( 18, 'Pasir Ris'),
        ( 19, 'Punggol'),
        ( 20, 'Queenstown'),
        ( 21, 'Sembawang'),
        ( 22, 'Sengkang'),
        ( 23, 'Serangoon'),
        ( 24, 'Tampines'),
        ( 25, 'Toa Payoh'),
        ( 26, 'Woodlands'),
        ( 27, 'Yishun');
    SQL

    # add_index :estates, :id,                unique: true

  end

  def down
    drop_table :estates
  end


end
