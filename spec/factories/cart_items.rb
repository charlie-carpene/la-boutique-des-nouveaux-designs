FactoryBot.define do
	factory :cart_item do
		item_qty_in_cart { 1 }
    association :cart
    association :item
	end
end
  