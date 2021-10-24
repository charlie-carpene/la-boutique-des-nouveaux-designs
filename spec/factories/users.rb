FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "gawain#{n}@yopmail.com" }

    password { "password" }
    password_confirmation { "password" }
    is_maker { false }

    trait :is_maker do
      is_maker { true }
      sequence(:email) { |n| "gradya#{n}@yopmail.com" }

      after(:build) do |user|
        user.shop = create(:shop, user: user)
      end
    end
  end
end

def maker_with_items_in_shop(items_count: 1, available_qty: Faker::Number.between(from: 1, to: 10), categories: [])
  create(:user, :is_maker) do |user|
    create(:shop, user: user) do |shop|
      item_s_with_pictures(
        items_count: items_count,
        available_qty: available_qty,
        shop: shop,
        categories: [categories.sample]      
      )
    end
  end
end

def user_with_items_in_cart(items_count: 1, item_qty_in_cart: 1, items: maker_with_items_in_shop)
  create(:user) do |user|
    create_list(:cart_item,
      items_count,
      cart: user.cart,
      item: items.sample,
      item_qty_in_cart: item_qty_in_cart
    )
  end
end
