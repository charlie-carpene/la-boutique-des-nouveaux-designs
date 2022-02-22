FactoryBot.define do
  factory :item do
    name { Faker::Creature::Cat.name }
    rich_description { Faker::Lorem.paragraph(sentence_count: 2) }
    price { 19 }
    weight { Faker::Number.number(digits: 4) }
    width { Faker::Number.number(digits: 2) }
    height { Faker::Number.number(digits: 2) }
    depth { Faker::Number.number(digits: 2) }
    available_qty { Faker::Number.between(from: 1, to: 10) }
    association :shop
  end
end

def item_s_with_pictures(
  available_qty: 1,
  pictures_count: 2,
  items_count: 1,
  shop: Shop.nil? ? FactoryBot.create(:shop) : Shop.all.sample,
  categories: []
)
  item_pictures = build_list(:item_picture, pictures_count)
  create_list(:item, 
    items_count,
    available_qty: available_qty,
    shop: shop,
    item_pictures: item_pictures,
    categories: categories
  )
end

def item_attr(shop_id)
  item_attr = attributes_for(:item)
  item_attr.reverse_merge!({shop_id: shop_id})
end
