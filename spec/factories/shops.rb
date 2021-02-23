FactoryBot.define do
  factory :shop do
    brand { "ShowerChiottes" }
    website { "www.showerchiott.es" }
    email_pro { "atelier@nouveauxdesigns.fr" }
    description { Faker::Quote.famous_last_words }
    compagny_id { Faker::Number.number(digits: 14) }
    association :user, :is_maker
  end
end