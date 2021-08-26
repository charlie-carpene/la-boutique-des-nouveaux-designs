class CartItem < ApplicationRecord
  belongs_to :cart
  belongs_to :item

  def add_qty_if_available_enough
    if self.item.available_qty > self.item_qty_in_cart
      self.update(item_qty_in_cart: self.item_qty_in_cart += 1)
      return true
    else
      return false
    end
  end

  def remove_qty
    if self.item_qty_in_cart > 1
      self.update(item_qty_in_cart: self.item_qty_in_cart -= 1)
      return true
    else
      return false
    end
  end

  def total_price
    return self.item.price * self.item_qty_in_cart
  end
end
