FactoryBot.define do
	factory :cart do
    association :user

		factory :cart_with_items do
			transient do
				items_count { 5 }
				item_qty_in_cart { 1 }
			end
  
			after(:create) do |cart, evaluator|
				create_list(:cart_item, evaluator.items_count, cart: cart, item_qty_in_cart: evaluator.item_qty_in_cart)
				cart.reload
			end
		end
	end
end
  