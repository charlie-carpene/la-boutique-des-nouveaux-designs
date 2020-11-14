class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items, dependent: :destroy
  has_many :items, through: :order_items

  def find_ordered_items(shop)
    return self.user.cart.items.where(shop: shop)
  end

  def create_ordered_items(shop)
    ordered_items = Array.new
    items = self.user.cart.items.where(shop: shop)
    items.each_with_index do |item, index|
      ordered_items[index] = OrderItem.create(order: self, item: item, qty_ordered: item.get_qty_in_cart(self.user))
    end
    return ordered_items
  end

  def add_all_ordered_items_to_stripe_session(ordered_items)
    items_array = Array.new
    ordered_items.each do |item|
      item_info = {
        price: item.stripe_price_id,
        quantity: item.get_qty_in_cart(self.user),
      }
      items_array.push(item_info)
    end
    return items_array
  end

  def total_price(ordered_items)
    total_price = 0
    ordered_items.each do |order_item|
      total_price += order_item.item.price * order_item.get_item_qty_in_cart
    end
    return total_price
  end

  def order_shipping_price
    weight = 0
    self.items.each do |item|
      weight += item.product_weight
    end
    return ApplicationController.helpers.shipping_cost(weight)
  end

  def total_price_with_shipping_cost(ordered_items)
    return total_price(ordered_items) + self.order_shipping_price
  end
end
