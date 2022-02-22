class AddTrackingIdToOrders < ActiveRecord::Migration[6.1]
  def change
    add_column :orders, :tracking_id, :string
  end
end
