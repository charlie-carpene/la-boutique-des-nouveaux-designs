class Shop < ApplicationRecord
  include ImageUploader::Attachment(:image)

  validates :brand, presence: true
  validates :description, presence: true
  validates :email_pro, presence: true, format: { with: /\A[a-z0-9\+\-_\.]+@[a-z\d\-.]+\.[a-z]+\z/i, message: "doit être un site web valide" }
  validates :website, allow_blank: true, format: { with: /\A^(https?:\/\/)?(www\.)?([a-zA-Z0-9]+(-?[a-zA-Z0-9])*\.)+[\w]{2,}(\/\S*)?$\z/, message: "doit être un site web valide" }
  validates :terms_of_service, acceptance: { message: 'doivent être acceptées' }
  validates :compagny_id, presence: true, format: { with: /\A\d+\z/, message: "doit être uniquement des chiffres"}, length: { is: 14 }
  validate :forbid_changing_uid, on: :update

  belongs_to :user
  has_one :address
  has_many :items

  def show_image(shop)
    if shop.image.present?
      return shop.image[:shop].url
    else
      return "logo_transparent.png"
    end
  end

  def can_receive_payments?
    uid? && provider? && access_code? && publishable_key? && refresh_token?
  end

  def siren
    self.compagny_id.to_s.slice(0..8)
  end

  private

  def forbid_changing_uid
    errors.add(:uid, "ne peut pas être modifié") unless (self.uid_was == nil) || !self.uid_changed?
  end
end
