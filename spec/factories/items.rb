require 'faker'

FactoryBot.define do
  factory :item do
    name { Faker::Creature::Cat.name }
    category { 0 }
    description { "etstsetes" }
    price { 19 }
    product_weight { 300 }
    available_qty { 1 }
    shop { 17 }
  end
end
