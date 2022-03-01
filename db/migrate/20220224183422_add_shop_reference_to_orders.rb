class AddShopReferenceToOrders < ActiveRecord::Migration[6.1]
  def change
    add_reference :orders, :shop

    Order.all.each do |order|
      order.shop_id = order.shop.id
      order.save
    end
  end
end
