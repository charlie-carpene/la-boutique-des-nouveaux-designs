FactoryBot.define do
  factory :category do
    name { Faker::Coffee.variety }
  end
end

def category_with_item_s(
    items_count: 1,
    item_shop: Shop.nil? ? FactoryBot.create(:shop) : Shop.all.sample
  )
  create(:category) do |category|
    item_s_with_pictures(
      pictures_count: 2,
      items_count: items_count,
      shop: item_shop,
      categories: [category]
    )
  end
end
