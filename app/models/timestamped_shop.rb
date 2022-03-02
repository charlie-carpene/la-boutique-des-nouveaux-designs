class TimestampedShop < ApplicationRecord

  belongs_to :timestamped_user
  belongs_to :timestamped_address, optional: true
  has_many :orders
end
