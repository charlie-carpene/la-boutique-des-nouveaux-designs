class AddDeliveryAddressToOrders < ActiveRecord::Migration[6.1]
  def change
    add_reference :orders, :address

    reversible do |dir|
      dir.up do
        Order.all.each do |order|
          order.address_id = order.user.addresses.last.id
          order.save
        end
      end

      dir.down do
      end
    end
  end
end
