FactoryBot.define do
    factory :item do
        name { Faker::Creature::Cat.name }
        category { Category.all.sample }
        description { Faker::TvShows::HowIMetYourMother.quote }
        price { Faker::Number.number(digits:2) }
        product_weight { Faker::Number.between(from: 1, to: 30000) }
        available_qty { Faker::Number.number(digits:1)}
        shop { Shop.all.sample }
    end
end