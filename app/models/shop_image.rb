class ShopImage < ApplicationRecord
  validate :images_limite_nbr

  include ImageUploader::Attachment(:image)
  belongs_to :shop

  private

  #method to limit the number of uploaded file to 7 (kbis, rib & up to 5 pictures) when a user fills the form to become a maker.
  def images_limite_nbr
    limit = 7
    if self.shop.shop_images.size > limit
      errors.add(:image_nbr_sent, "doit être inférieur à #{limit}.")
    end
  end
end
