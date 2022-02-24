class RemoveUserForeignKeyFromOrders < ActiveRecord::Migration[6.1]
  def change
    remove_foreign_key :orders, :users
  end
end
