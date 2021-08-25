FactoryBot.define do
  factory :item do
    name { Faker::Creature::Cat.name }
    rich_description { Faker::Lorem.paragraph(sentence_count: 2) }
    price { 19 }
    product_weight { Faker::Number.number(digits: 4) }
    available_qty { Faker::Number.number(digits: 1) }
    association :categories
    association :shop

    factory :item_with_pictures do
      transient do
        pictures_count { 5 }
      end

      after(:create) do |item, evaluator|
        create_list(:item_picture, evaluator.pictures_count, item: item)
        item.reload
      end
    end
  end
end