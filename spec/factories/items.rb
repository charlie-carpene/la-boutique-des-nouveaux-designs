require 'faker'

FactoryBot.define do
  factory :item do
    name { Faker::Creature::Cat.name }
    description { "etstsetes" }
    price { 19 }
    product_weight { 300 }
    available_qty { 1 }
    association :category
    association :shop
  end
end
