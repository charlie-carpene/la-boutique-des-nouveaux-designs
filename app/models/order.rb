class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items, dependent: :destroy
  has_many :items, through: :order_items

  def find_ordered_items_in_cart(shop)
    ordered_cart_items = Array.new
    order_items = self.user.cart.items.where(shop: shop)
    order_items.each_with_index do |item, index|
      ordered_cart_items[index] = self.user.cart.cart_items.find_by(item: order_items[index])
    end
    return ordered_cart_items
  end

  def create_ordered_items(shop)
    ordered_items = Array.new
    items = self.user.cart.items.where(shop: shop)
    items.each_with_index do |item, index|
      ordered_items[index] = OrderItem.create(order: self, item: item, qty_ordered: item.get_qty_in_cart(self.user))
    end
    return ordered_items
  end

  def add_all_ordered_items_to_stripe_session(ordered_cart_items)
    items_array = Array.new
    ordered_cart_items.each do |ordered_cart_item|
      item_info = {
        price: ordered_cart_item.item.stripe_price_id,
        quantity: ordered_cart_item.item_qty_in_cart,
      }
      items_array.push(item_info)
    end
    return items_array
  end

  def total_price(ordered_items)
    total_price = 0
    ordered_items.each do |cart_item|
      total_price += cart_item.item.price * cart_item.item_qty_in_cart
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
