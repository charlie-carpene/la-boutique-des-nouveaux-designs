class CreateTimestampedItems < ActiveRecord::Migration[6.1]
  def change
    create_table :timestamped_items do |t|
      t.string :name
      t.integer :price
      t.integer :qty_ordered
      t.string :stripe_price_id
      t.string :stripe_product_id
      t.decimal :width
      t.decimal :height
      t.decimal :depth
      t.integer :weight
      t.references :timestamped_shop, null: false, foreign_key: true

      t.timestamps
    end

    add_reference :order_items, :timestamped_item

    reversible do |dir|
      dir.up do
        Order.all.each do |order|
          order.order_items.each do |order_item|
            timestamped_item =  TimestampedItem.create(
              timestamped_shop_id: order.timestamped_shop.id,
              name: order_item.item.name,
              price: order_item.price,
              qty_ordered: order_item.qty_ordered,
              stripe_price_id: order_item.item.stripe_price_id,
              stripe_product_id: order_item.item.stripe_product_id,
              width: order_item.item.width,
              height: order_item.item.height,
              depth: order_item.item.depth,
              weight: order_item.item.weight,
            )

            order_item.update(timestamped_item_id: timestamped_item.id)
          end
        end

        add_foreign_key :order_items, :timestamped_items
      end
  
      dir.down do
        remove_foreign_key :order_items, :timestamped_items

        TimestampedItem.all.each do |timestamped_item|
          timestamped_item.destroy
        end
      end
    end  
  end
end
