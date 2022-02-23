class TimestampedUser < ApplicationRecord
  has_one :timestamped_address
  has_many :orders
end
