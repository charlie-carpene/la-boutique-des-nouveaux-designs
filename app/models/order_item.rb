class OrderItem < ApplicationRecord
  after_create :update_available_item_qty

  belongs_to :order
  belongs_to :item

  def get_item_qty_in_cart
    CartItem.find_by(cart_id: self.order.user.cart.id, item_id: self.item_id).item_qty_in_cart
  end

  def get_total_price_with_shipping_cost
    return self.get_item_qty_in_cart * self.item.price
  end

  private

  def update_available_item_qty
    self.item.update_qty_when_ordered(self.order.user.cart, self.qty_ordered)
  end
end
