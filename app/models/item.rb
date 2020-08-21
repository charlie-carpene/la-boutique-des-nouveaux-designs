class Item < ApplicationRecord
  validates :name, presence: true
  validates :price, presence: true
  validates :available_qty, presence: true
  validates :description, presence: true
  validates :category_id, presence: true
  validates :product_weight, presence: true

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

end
