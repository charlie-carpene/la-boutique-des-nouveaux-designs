FactoryBot.define do
  factory :timestamped_item do
    name { "MyString" }
    price { 1 }
    qty_ordered { 1 }
    stripe_price_id { "MyString" }
    stripe_product_id { "MyString" }
    width { "9.99" }
    height { "9.99" }
    depth { "9.99" }
    weight { 1 }
  end
end
