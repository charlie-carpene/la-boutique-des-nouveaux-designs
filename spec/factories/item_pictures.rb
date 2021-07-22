require 'faker'

FactoryBot.define do
  factory :item_picture do
    picture_data { Faker::Quotes::Chiquito.joke }
  end
end
