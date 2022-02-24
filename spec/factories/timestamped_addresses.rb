FactoryBot.define do
  factory :timestamped_address do
    timestamped_user { nil }
    first_name { "MyString" }
    last_name { "MyString" }
    address_line_1 { "MyString" }
    address_line_2 { "MyString" }
    zip_code { "MyString" }
    city { "MyString" }
  end
end
