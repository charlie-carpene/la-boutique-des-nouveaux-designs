require './app/package_helpers/package.rb'

class Order < ApplicationRecord
  validates :tracking_id, length: { in: 11..15 }, format: { with: /\A[a-zA-Z0-9]+\z/, message: I18n.t("validate.errors.only_letters_and_numbers_allowed") }, allow_blank: true
  
  before_validation :timestamp_database, on: :create
  after_update :send_update_email, if: :saved_change_to_tracking_id?

  belongs_to :user
  belongs_to :address
  belongs_to :shop
  belongs_to :timestamped_user
  belongs_to :timestamped_shop
  has_many :order_items, dependent: :destroy
  has_many :items, through: :order_items

  def find_ordered_items_in_cart(shop)
    ordered_cart_items = Array.new
    order_items = self.user.cart.items.where(shop: shop)
    order_items.each_with_index do |item, index|
      ordered_cart_items[index] = self.user.cart.cart_items.find_by(item: order_items[index])
      if ordered_cart_items[index].item.available_qty < 1
        return [0, ordered_cart_items[index]]
      elsif ordered_cart_items[index].item_qty_in_cart > ordered_cart_items[index].item.available_qty
        return [1, ordered_cart_items[index]]
      end
    end
    return ordered_cart_items
  end

  def shop
    return self.items.sample.shop
  end

  def create_ordered_items(shop)
    ordered_items = Array.new
    items = self.user.cart.items.where(shop: shop)
    items.each_with_index do |item, index|
      ordered_items[index] = OrderItem.create(order: self, item: item, qty_ordered: item.get_qty_in_cart(self.user), price: item.price)
    end

    send_create_emails
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

  def total_price
    price = 0
    self.order_items.each do |order_item|
      price += order_item.price * order_item.qty_ordered
    end
    package = create_package(self.order_items)
    price += package.shipping_price

    return price
  end

  def total_price_for_new_order(ordered_cart_items)
    total_price = 0
    ordered_cart_items.each do |cart_item|
      total_price += cart_item.item.price * cart_item.item_qty_in_cart
    end
    return total_price
  end

  def shipping_price(ordered_items)
    package = create_package(ordered_items)
    return package.shipping_price
  end 

  def create_package(items)
    return Package.new.add_all_items_to_package(items)
  end

  def tracking_url
    return "https://www.laposte.fr/outils/suivre-vos-envois?code=#{self.tracking_id}"
  end

  private

  def send_create_emails
    UserMailer.new_order_from_customer(self).deliver_now
    UserMailer.new_order_for_maker(self).deliver_now
    AdminMailer.new_order_for_admin(self).deliver_now
  end

  def send_update_email
    UserMailer.tracking_id_for_customer(self).deliver_now
  end

  def timestamp_database
    if TimestampedUser.where(old_id: self.user.id).present?
      timestamped_customer = TimestampedUser.where(old_id: self.user.id).first
      timestamped_customer.update(email: self.user.email) if timestamped_customer.email != self.user.email
    else
      timestamped_customer = TimestampedUser.create(
        email: self.user.email,
        old_id: self.user.id
      )
    end

    unless self.timestamped_user.present?
      timestamped_customer_address = TimestampedAddress.create(
        first_name: self.address.first_name,
        last_name: self.address.last_name,
        address_line_1: self.address.address_line_1,
        address_line_2: self.address.address_line_2,
        zip_code: self.address.zip_code,
        city: self.address.city,
        timestamped_user: timestamped_customer
      )
    end

    timestamped_maker = TimestampedUser.new(
      email: self.shop.user.email,
      old_id: self.shop.user.id
    )

    timestamped_maker_address = TimestampedAddress.new(
      first_name: self.shop.address.first_name,
      last_name: self.shop.address.last_name,
      address_line_1: self.shop.address.address_line_1,
      address_line_2: self.shop.address.address_line_2,
      zip_code: self.shop.address.zip_code,
      city: self.shop.address.city,
      timestamped_user: timestamped_maker
    )

    if TimestampedShop.where(company_id: self.shop.company_id).present?
      timestamped_shop = TimestampedShop.where(company_id: self.shop.company_id).first
      timestamped_shop.timestamped_user.update(timestamped_maker.attributes.except("id", "created_at", "updated_at"))
      timestamped_shop.timestamped_user.timestamped_address.update(timestamped_maker_address.attributes.except("id", "timestamped_user_id", "created_at", "updated_at"))
    else
      timestamped_maker.save
      timestamped_maker_address.save
      timestamped_shop = TimestampedShop.create(
        brand: self.shop.brand,
        email_pro: self.shop.email_pro,
        phone: self.shop.phone,
        website: self.shop.website,
        company_id: self.shop.company_id,
        uid: self.shop.uid,
        image_data: self.shop.image_data,
        timestamped_user: timestamped_maker,
        timestamped_address: timestamped_maker_address,
      )
    end
    
    self.timestamped_user_id = timestamped_customer.id 
    self.timestamped_shop_id = timestamped_shop.id
  end
end
