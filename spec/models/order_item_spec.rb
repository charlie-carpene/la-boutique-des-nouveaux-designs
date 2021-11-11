require 'rails_helper'

RSpec.describe OrderItem, type: :model do
	let!(:categories) { create_list(:category, 2)}
	let!(:maker_with_items) { maker_with_items_in_shop(items_count: 2, categories: categories) }
	let!(:user_with_items) { user_with_items_in_cart(items: maker_with_items.shop.items) }
	let!(:order) do
		o = create(:order, user: user_with_items)
		create(:order_item, price: user_with_items.cart.items.first.price, order: o, item: user_with_items.cart.items.first)
		return o
	end

	context 'method' do
		it "get_item_qty_in_cart should return the item's qty the user put in its cart before order_item is created" do
			item_in_cart = user_with_items.cart.items.first
			build_oi = build(:order_item, price: user_with_items.cart.items.first.price, order: order, item: user_with_items.cart.items.first)
			expect(build_oi.get_item_qty_in_cart).to eq(item_in_cart.get_qty_in_cart(user_with_items))
		end
	end
end
