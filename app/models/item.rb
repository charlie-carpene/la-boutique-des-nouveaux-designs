class Item < ApplicationRecord
  validates :name, presence: true
  validates :price, presence: true
  validates :available_qty, presence: true
  validates :description, presence: true
  validates :category_id, presence: true

  belongs_to :shop
  belongs_to :category
  has_many :item_pictures, dependent: :destroy
  accepts_nested_attributes_for :item_pictures, allow_destroy: true
end
