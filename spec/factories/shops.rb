require './spec/support/shrine_helpers.rb'

FactoryBot.define do
  factory :shop do
    brand { "ShowerChiottes" }
    website { "www.showerchiott.es" }
    email_pro { "atelier@nouveauxdesigns.fr" }
    rich_description { Faker::Quote.famous_last_words }
    company_id { Faker::Number.number(digits: 14) }
    image_data { TestData.image_data }
    association :user, :is_maker
    association :address, strategy: :null
  end
end