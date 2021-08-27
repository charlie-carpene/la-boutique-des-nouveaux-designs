FactoryBot.define do
  factory :user do
    email { "gawain@yopmail.com" }
    password { "password" }
    password_confirmation { "password" }
    is_maker { false }

    trait :is_maker do
      is_maker { true }

      after(:build) do |user|
        user.shop = create(:shop, user: user)
      end
    end
  end
end

def maker_with_items_in_shop(items_count: 1, available_qty: Faker::Number.between(from: 1, to: 10), categories: create_list(:category, 4))
  create(:user, :is_maker, email: "gradya@yopmail.com") do |user|
    create(:shop, user: user) do |shop|
      create_list(:item,
        items_count,
        categories: [categories.sample],
        shop: shop,
        available_qty: available_qty
      )
    end
  end
end

def user_with_items_in_cart(items_count: 1, item_qty_in_cart: 1, items: maker_with_items)
  create(:user) do |user|
    create_list(:cart_item,
      items_count,
      cart: user.cart,
      item: items.sample,
      item_qty_in_cart: item_qty_in_cart
    )
  end
end
