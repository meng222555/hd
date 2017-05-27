class AddPhoneToUsers < ActiveRecord::Migration[5.0]
  def change
    change_table :users do |t|
      t.string :address, :limit => 30, null: true
      t.string :postal_code, :limit => 15, null: true
      t.string :phone, :limit => 15, null: true
    end
  end
end
