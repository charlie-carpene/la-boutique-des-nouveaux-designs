class OrderItem < ApplicationRecord
  after_create :create_stripe_product_and_price

  belongs_to :order
  belongs_to :item

  def get_item_qty_in_cart
    CartItem.find_by(cart_id: self.order.user.cart.id, item_id: self.item_id).item_qty_in_cart
  end

  private

  def create_stripe_product_and_price
    stripe_product = Stripe::Product.create({
      name: self.item.name,
    })

    stripe_price = Stripe::Price.create({
      product: stripe_product.id,
      unit_amount: "#{self.item.price}" + "00",
      currency: 'eur',
    })
    self.update(stripe_price_id: stripe_price.id)
  end
end
