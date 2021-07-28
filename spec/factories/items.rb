require 'faker'

FactoryBot.define do
  factory :item do
    name { Faker::Creature::Cat.name }
    description { Faker::Lorem.paragraph(sentence_count: 2) }
    price { 19 }
    product_weight { 300 }
    available_qty { 1 }
    association :categories
    association :shop
  end
end
