FactoryBot.define do
  factory :user do
    email { "gawain@yopmail.com" }
    password { "password" }
    password_confirmation { "password" }
    is_maker { false }

    trait :is_maker do
      is_maker { true }
    end
  end
end
