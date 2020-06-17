class Cart < ApplicationRecord
  belongs_to :user
  has_many :cart_items, dependent: :destroy
  has_many :items, through: :cart_items

  def get_items_shops
    shops_array = Array.new
    self.items.each do |item|
      unless shops_array.include? item.shop
        shops_array.push(item.shop)
      end
    end
    return shops_array
  end

  def get_cart_items_from_a_specific_shop(shop)
    self.cart_items.where(item: self.items.where(shop: shop))
  end
end
