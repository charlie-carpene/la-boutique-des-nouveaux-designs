class ItemPicture < ApplicationRecord
  validate :pictures_limite_nbr

  include PictureUploader::Attachment(:picture)
  belongs_to :item

  private

  #method to limit the number of uploaded file to 10 when a maker create an item. // was used with shop_images, to be used with item_pictures
  def pictures_limite_nbr
    limit = 10
    if self.item.item_pictures.count >= limit
      errors.add(:picture_nbr_sent, "doit être inférieur à #{limit}.")
    end
  end

end
