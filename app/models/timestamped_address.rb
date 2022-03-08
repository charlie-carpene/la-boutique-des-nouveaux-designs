class TimestampedAddress < ApplicationRecord
  belongs_to :timestamped_user

  has_one :timestamped_shop
end
