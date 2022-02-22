class AddDeliveryAddressToUser < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :delivery_address, :bigint
  end
end
