class TimestampedItem < ApplicationRecord
  belongs_to :timestamped_shop
  has_one :order_item
  has_one :order, through: :order_item
end
