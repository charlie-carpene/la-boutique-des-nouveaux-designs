class User < ApplicationRecord
  after_create :welcome_send

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :addresses
  has_one :shop
  has_one :admin

  def welcome_send
    UserMailer.welcome_email(self).deliver_now
  end

  def is_admin?
    self.admin.present?
  end

end
