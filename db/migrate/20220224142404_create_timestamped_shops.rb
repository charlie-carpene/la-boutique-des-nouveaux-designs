class CreateTimestampedShops < ActiveRecord::Migration[6.1]
  def change
    add_column :shops, :phone, :string

    create_table :timestamped_shops do |t|
      t.string :brand
      t.string :email_pro
      t.string :phone
      t.string :website
      t.string :company_id
      t.string :uid
      t.text :image_data
      t.references :timestamped_user, null: false, foreign_key: true
      t.references :timestamped_address, null: false, foreign_key: true

      t.timestamps
    end

    add_reference :orders, :timestamped_shop

    reversible do |dir|
      dir.up do
        add_foreign_key :orders, :timestamped_shops
        
        Order.set_callback(:validation, :before, :timestamp_database)
        
        Order.all.each do |order|
          order.save
        end

        Order.reset_callbacks(:validation)
      end

      dir.down do
        remove_foreign_key :orders, :timestamped_shops

        TimestampedShop.all.each do |shop|
          shop.destroy
          shop.timestamped_address.destroy
          shop.timestamped_user.destroy
        end
      end
    end
  end
end
