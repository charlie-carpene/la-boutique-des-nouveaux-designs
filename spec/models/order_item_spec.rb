require 'rails_helper'

RSpec.describe OrderItem, type: :model do
	let!(:categories) { create_list(:category, 2)}
	let!(:maker_with_items) { maker_with_items_in_shop(items_count: 2, categories: categories) }
	let!(:user_with_items) { user_with_items_in_cart(items_count: 2, items: maker_with_items.shop.items) }
	let!(:order) do
		o = create(:order, user: user_with_items)
		create(:order_item, price: user_with_items.cart.items.first.price, order: o, item: user_with_items.cart.items.first)
		return o
	end

	context 'method' do
		it "get_item_qty_in_cart should return the item's qty the user put in its cart" do
			item_ordered = user_with_items.cart.items.first
			expect(order.order_items.first.get_item_qty_in_cart).to eq(item_ordered.get_qty_in_cart(user_with_items))
		end
	end
end