class Item < ApplicationRecord
  validates :name, presence: true
  validates :price, presence: true
  validates :available_qty, presence: true
  validates :weight, presence: true
  validates :width, presence: true, inclusion: { in: 0..100, message: I18n.t("item.validation.errors.dimensions")}
  validates :height, presence: true, inclusion: { in: 0..100, message: I18n.t("item.validation.errors.dimensions")}
  validates :depth, presence: true, inclusion: { in: 0..100, message: I18n.t("item.validation.errors.dimensions")}
  validates :rich_description, no_attachments: true
  validates :item_pictures, nbr_of_pictures: true

  after_create :create_stripe_product_and_price
  before_update :update_stripe_info
  after_destroy :destroy_stripe_product
  after_update :generate_new_item_picture_location, if: :saved_change_to_name?

  belongs_to :shop
  has_many :item_categories, dependent: :destroy
  has_many :categories, through: :item_categories
  has_many :cart_items, dependent: :destroy
  has_many :carts, through: :cart_items
  has_many :item_pictures, dependent: :destroy
  accepts_nested_attributes_for :item_pictures, allow_destroy: true
  has_many :order_items
  has_many :orders, through: :order_items

  has_rich_text :rich_description

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

  def cover_picture_with_fallback(img_type)
    if self.item_pictures.where(id: self.cover_picture).exists?
      return self.item_pictures.find(self.cover_picture).picture_url(img_type)
    elsif self.item_pictures.exists?
      return self.item_pictures.last.picture_url(img_type)
    else
      return "img_items/adnd_squarre_0.svg"
    end
  end

  private

  def create_stripe_product_and_price
    stripe_product = Stripe::Product.create({
      name: self.name,
      description: self.rich_description.body.to_plain_text,
    })

    stripe_price = Stripe::Price.create({
      product: stripe_product.id,
      unit_amount: "#{self.price}" + "00",
      currency: 'eur',
    })
    self.update(stripe_price_id: stripe_price.id, stripe_product_id: stripe_product.id)
  end

  def update_stripe_info
    if changes_to_save.keys.any? { |value| ["name", "rich_description"].include?(value) }
      Stripe::Product.update(self.stripe_product_id, {
        name: self.name,
        description: self.rich_description.body.to_plain_text,
      })
    end
    if changes_to_save.keys.any? { |value| value == "price" }
      Stripe::Price.update(self.stripe_price_id, {
        active: false
      })
      stripe_price = Stripe::Price.create({
        product: self.stripe_product_id,
        unit_amount: "#{changes_to_save["price"].last}" + "00",
        currency: 'eur',
      })
      self.stripe_price_id = stripe_price.id
    end
  end

  def destroy_stripe_product
    Stripe::Product.update(self.stripe_product_id, {
      active: false
    })
    Stripe::Price.update(self.stripe_price_id, {
      active: false
    })
  end

  def generate_new_item_picture_location
    self.item_pictures.each do |item_picture|
      item_picture.send(:generate_new_picture_location)
    end
  end
end
