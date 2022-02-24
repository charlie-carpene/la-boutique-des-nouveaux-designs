class AddShopReferenceToOrders < ActiveRecord::Migration[6.1]
  def change
    add_reference :orders, :shop

    Order.skip_callback(:validation, :before, :timestamp_database)
    Order.skip_callback(:update, :after, :send_update_email)

    Order.all.each do |order|
      order.shop_id = order.shop.id
      order.save
    end

    Order.set_callback(:validation, :before, :timestamp_database)
    Order.set_callback(:update, :after, :send_update_email)
  end
end
