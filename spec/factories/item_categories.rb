FactoryBot.define do
  factory :item_category do
    association :item
    association :category
  end
end
