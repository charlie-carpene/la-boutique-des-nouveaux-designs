FactoryBot.define do
  factory :item do
    name { Faker::Creature::Cat.name }
    description { Faker::Lorem.paragraph(sentence_count: 2) }
    price { 19 }
    product_weight { Faker::Number.number(digits: 4) }
    available_qty { Faker::Number.number(digits: 1) }
    association :categories
    association :shop
  end
end
