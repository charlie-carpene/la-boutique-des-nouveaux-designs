class ShopImage < ApplicationRecord
  include ImageUploader::Attachment(:image)
  belongs_to :shop
end
