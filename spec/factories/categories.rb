FactoryBot.define do
  factory :category do
    name { Faker::Coffee.variety }

    factory :category_with_items do
      transient do
        items_count { 5 }
        shop { create(:shop) }
      end

      after(:create) do |category, evaluator|
        create_list(:item, evaluator.items_count, categories: [category], shop: evaluator.shop)
        category.reload
      end
    end
  end
end

def category_with_item_s(
    items_count: 1,
    shop: Shop.nil? ? FactoryBot.create(:shop) : Shop.all.sample
  )
  create(:category) do |category|
    item_s_with_pictures(
      pictures_count: 2,
      items_count: items_count,
      shop: shop,
      category: category
    )
  end
end

def category_with_items_in_it(items_count: 5)
  create(:category) do |category|
    items_with_pictures(
      items_count,
      category: category
    )
  end
end