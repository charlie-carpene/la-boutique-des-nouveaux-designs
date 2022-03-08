class TimestampedUser < ApplicationRecord
  has_one :timestamped_address
  has_one :timestamped_shop
  has_many :orders
end
