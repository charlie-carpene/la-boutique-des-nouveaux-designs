FactoryBot.define do
  factory :category do
    name { Faker::Coffee.variety }
  end
end