class CreateTimestampedUsersAndAddresses < ActiveRecord::Migration[6.1]
  def change
    reversible do |dir|
      dir.up do
        Order.all.each do |order|
          if TimestampedUser.where(old_id: order.user.id).blank?
            TimestampedUser.create(email: order.user.email, old_id: order.user.id)
          end

          timestamped_user = TimestampedUser.where(old_id: order.user.id).first

          if TimestampedAddress.where(first_name: order.address.first_name).blank?
            TimestampedAddress.create(
              first_name: order.address.first_name,
              last_name: order.address.last_name,
              address_line_1: order.address.address_line_1,
              address_line_2: order.address.address_line_2,
              zip_code: order.address.zip_code,
              city: order.address.city,
              timestamped_user: timestamped_user
            )
          end

          order.timestamped_user_id = timestamped_user.id
          order.save
        end
      end

      dir.down do
        TimestampedAddress.all.each do |address|
          address.destroy
        end

        TimestampedUser.all.each do |user|
          user.destroy
        end
      end
    end
  end
end
