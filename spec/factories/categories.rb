FactoryBot.define do
  factory :category do
    name { Faker::Coffee.variety }

    factory :category_with_items do
      transient do
        items_count { 5 }
        shop { create(:shop) }
      end

      after(:create) do |category, evaluator|
        puts "*" * 30
        puts category.inspect
        puts "*" * 30
        create_list(:item, evaluator.items_count, categories: [category], shop: evaluator.shop)
        category.reload
      end
    end
  end
end