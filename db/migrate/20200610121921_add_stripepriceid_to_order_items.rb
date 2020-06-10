class AddStripepriceidToOrderItems < ActiveRecord::Migration[6.0]
  def change
    add_column :order_items, :stripe_price_id, :string
  end
end
