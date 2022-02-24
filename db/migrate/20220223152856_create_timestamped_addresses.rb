class CreateTimestampedAddresses < ActiveRecord::Migration[6.1]
  def change
    create_table :timestamped_addresses do |t|
      t.references :timestamped_user, null: false, foreign_key: true
      t.string :first_name
      t.string :last_name
      t.string :address_line_1
      t.string :address_line_2
      t.string :zip_code
      t.string :city

      t.timestamps
    end
  end
end
