class AddQtyOrderedToOrderItem < ActiveRecord::Migration[6.0]
  def change
    add_column :order_items, :qty_ordered, :integer
  end
end
