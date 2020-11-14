class Item < ApplicationRecord
  validates :name, presence: true
  validates :price, presence: true
  validates :available_qty, presence: true
  validates :description, presence: true
  validates :category_id, presence: true
  validates :product_weight, presence: true

  after_create :create_stripe_product_and_price

  belongs_to :shop
  belongs_to :category
  has_many :cart_items, dependent: :destroy
  has_many :carts, through: :cart_items
  has_many :item_pictures, dependent: :destroy
  accepts_nested_attributes_for :item_pictures, allow_destroy: true
  has_many :order_items
  has_many :orders, through: :order_items

  def price_with_shipping_cost(shipping_cost)
    return shipping_cost + self.price
  end

  def get_qty_in_cart(user)
    self.cart_items.where(cart: user.cart).first.item_qty_in_cart
  end

  def update_qty_when_ordered(cart, qty)
    if self.available_qty - qty > 0
      self.update(available_qty: self.available_qty - qty)
    else
      self.update(available_qty: 0)
    end

    @cart_item = cart.cart_items.find_by(item: self)
    CartItem.destroy(@cart_item.id)
  end

  private

  def create_stripe_product_and_price
    stripe_product = Stripe::Product.create({
      name: self.name,
    })

    stripe_price = Stripe::Price.create({
      product: stripe_product.id,
      unit_amount: "#{self.price}" + "00",
      currency: 'eur',
    })
    self.update(stripe_price_id: stripe_price.id)
  end

end
