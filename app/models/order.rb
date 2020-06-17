class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items, dependent: :destroy
  has_many :items, through: :order_items

  def create_ordered_items(shop)
    ordered_items = Array.new
    items = self.user.cart.items.where(shop: shop)
    items.each_with_index do |item, index|
      ordered_items[index] = OrderItem.create(order: self, item: item)
    end
    return ordered_items
  end

  def add_all_ordered_items_to_stripe_session(ordered_items)
    items_array = Array.new
    ordered_items.each do |ordered_item|
      item_info = {
        price: ordered_item.stripe_price_id,
        quantity: ordered_item.get_item_qty_in_cart,
      }
      items_array.push(item_info)
    end
    return items_array
  end

  def total_price(ordered_items)
    total_price = 0
    ordered_items.each do |order_item|
      total_price += order_item.item.price
    end
    return total_price
  end
end
