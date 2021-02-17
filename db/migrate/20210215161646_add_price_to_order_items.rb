class AddPriceToOrderItems < ActiveRecord::Migration[6.1]
  def change
    add_column :order_items, :price, :integer
  end
end
