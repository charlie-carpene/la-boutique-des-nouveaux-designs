class AddAddressToShops < ActiveRecord::Migration[6.1]
  def change
    add_reference :shops, :address, foreign_key: true
  end
end
