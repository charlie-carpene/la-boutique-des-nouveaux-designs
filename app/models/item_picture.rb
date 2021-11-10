class ItemPicture < ApplicationRecord

  include PictureUploader::Attachment(:picture)
  belongs_to :item

end
