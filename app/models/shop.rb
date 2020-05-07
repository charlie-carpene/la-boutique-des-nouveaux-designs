class Shop < ApplicationRecord
  validates :brand, presence: true
  validates :description, presence: true
  validates :email_pro, presence: true, format: { with: /\A[a-z0-9\+\-_\.]+@[a-z\d\-.]+\.[a-z]+\z/i, message: "doit être un site web valide" }
  validates :website, allow_blank: true, format: { with: /\A^(https?:\/\/)?(www\.)?([a-zA-Z0-9]+(-?[a-zA-Z0-9])*\.)+[\w]{2,}(\/\S*)?$\z/, message: "doit être un site web valide" }

  belongs_to :user
  has_one :address
  has_many :shop_images, dependent: :destroy
  accepts_nested_attributes_for :shop_images, allow_destroy: true

end
