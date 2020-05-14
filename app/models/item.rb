class Item < ApplicationRecord
  validates :name, presence: true
  validates :price, presence: true
  validates :available_qty, presence: true
  validates :description, presence: true
  validates :category_id, presence: true

  belongs_to :shop
  belongs_to :category
end
