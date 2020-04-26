class User < ApplicationRecord
  after_create :welcome_send

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :addresses
  has_one :shop

  def welcome_send
    UserMailer.welcome_email(self).deliver_now
  end
end
