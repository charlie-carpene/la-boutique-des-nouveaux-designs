FactoryBot.define do
	factory :order_item do
		qty_ordered { 1 }
		price { self.item.price }
		association :order
		association :item
	end
end
