class User < ApplicationRecord
  after_create :create_cart
  after_create :welcome_send

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :addresses
  has_one :cart, dependent: :destroy
  has_one :shop
  has_one :admin
  has_many :orders

  private

  def welcome_send
    #UserMailer.welcome_email(self).deliver_now
  end

  def create_cart
    Cart.create(user: self)
  end
end
