class TimestampedItem < ApplicationRecord
  belongs_to :timestamped_shop
  has_many :order_items
  has_many :orders, through: :order_items
end
