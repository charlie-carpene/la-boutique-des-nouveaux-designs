FactoryBot.define do
  factory :timestamped_shop do
    brand { "MyString" }
    email_pro { "MyString" }
    phone { "MyString" }
    website { "MyString" }
    company_id { "MyString" }
    uid { "MyString" }
    image_data { "MyText" }
    timestamped_user { nil }
    timestamped_address { nil }
  end
end
