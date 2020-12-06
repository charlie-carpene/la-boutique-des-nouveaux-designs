class CartItem < ApplicationRecord
  belongs_to :cart
  belongs_to :item

  def add_qty_if_available_enough(cart_item)
    if cart_item.item.available_qty > cart_item.item_qty_in_cart
      cart_item.update(item_qty_in_cart: cart_item.item_qty_in_cart += 1)
      return true
    else
      return false
    end
  end

  def remove_qty(cart_item)
    if cart_item.item_qty_in_cart > 1
      cart_item.update(item_qty_in_cart: cart_item.item_qty_in_cart -= 1)
      return true
    else
      return false
    end
  end

  def total_price
    return self.item.price * self.item_qty_in_cart
  end
end
