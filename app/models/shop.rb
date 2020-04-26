class Shop < ApplicationRecord
  validates :brand, presence: true
  validates :description, presence: true
  validates :website, presence: true, format: { with: /\A^(https?:\/\/)?(www\.)?([a-zA-Z0-9]+(-?[a-zA-Z0-9])*\.)+[\w]{2,}(\/\S*)?$\z/, message: "doit être un site web valide" }

  belongs_to :user
  has_one :address
end
