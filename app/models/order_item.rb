class OrderItem < ApplicationRecord
  before_validation :timestamp_item, on: :create
  after_create :update_available_item_qty

  belongs_to :order
  belongs_to :item
  belongs_to :timestamped_item

  def get_item_qty_in_cart
    CartItem.find_by(cart_id: self.order.user.cart.id, item_id: self.item_id).item_qty_in_cart
  end

  private

  def update_available_item_qty
    self.item.update_qty_when_ordered(self.order.user.cart, self.qty_ordered)
  end

  def timestamp_item
    timestamped_item = TimestampedItem.create(
      timestamped_shop_id: self.order.timestamped_shop.id,
      name: self.item.name,
      price: self.price,
      qty_ordered: self.qty_ordered,
      stripe_price_id: self.item.stripe_price_id,
      stripe_product_id: self.item.stripe_product_id,
      width: self.item.width,
      height: self.item.height,
      depth: self.item.depth,
      weight: self.item.weight,
    )

    self.update(timestamped_item_id: timestamped_item.id)
  end
end
