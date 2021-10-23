FactoryBot.define do
  factory :item do
    name { Faker::Creature::Cat.name }
    rich_description { Faker::Lorem.paragraph(sentence_count: 2) }
    price { 19 }
    product_weight { Faker::Number.number(digits: 4) }
    available_qty { Faker::Number.between(from: 1, to: 10) }
    association :shop
  end
end

def item_s_with_pictures(
  pictures_count: 5,
  items_count: 3,
  shop: Shop.nil? ? FactoryBot.create(:shop) : Shop.all.sample,
  category: nil
)
  item_pictures = build_list(:item_picture, pictures_count)
  create_list(:item, 
    items_count,
    shop: shop,
    item_pictures: item_pictures
  )
end