class RemoveStripepriceidFromOrderItems < ActiveRecord::Migration[6.0]
  def change

    remove_column :order_items, :stripe_price_id, :string
  end
end
