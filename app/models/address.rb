class Address < ApplicationRecord
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :address_line_1, presence: true
  validates :city, presence: true
  validates :zip_code, presence: true, format: { with: /\A(([0-8][0-9])|(9[0-5])|(2[ab]))[0-9]{3}\z/, message: "doit être un code postal français valide" }

  belongs_to :user, optional: true
  has_one :shop, required: false
  has_many :orders
end
