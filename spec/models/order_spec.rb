require 'rails_helper'

RSpec.describe Order, type: :model do
  let!(:categories) { create_list(:category, 4) }
  let!(:maker_with_items) { maker_with_items_in_shop(items_count: 2, categories: categories) }
  let!(:user_with_items) { user_with_items_in_cart(items: maker_with_items.shop.items) }
	let!(:address) { create(:address, user: user_with_items) }
  let!(:item) { item_s_with_pictures(available_qty: 2, categories: [categories.sample], shop: maker_with_items.shop).first }
	let!(:cart_item) { create(:cart_item, cart: user_with_items.cart, item: item) }
	let!(:order) do
		o = create(:order, user: user_with_items, address: address)
		create(:order_item, price: item.price, order: o, item: item)
		return o
	end

	it 'should create a valid instance of Order' do
		expect(order).to be_valid
	end

	context 'method' do
		it 'find_ordered_items_in_cart(shop) should return [cart_items] of the right shop' do
			expect(order.find_ordered_items_in_cart(maker_with_items.shop).count).to eq(2)
			expect(order.find_ordered_items_in_cart(maker_with_items.shop).first.id).to eq(user_with_items.cart.cart_items.first.id)
		end

		it 'shop' do
			expect(order.shop).to eq(maker_with_items.shop)
		end

		it 'create_ordered_items(shop) should create OrderItem' do
			expect{ order.create_ordered_items(maker_with_items.shop) }.to change{ OrderItem.count }.from(1).to(3)
		end

		it 'add_all_ordered_items_to_stripe_session(ordered_cart_items)' do
			expect(
				order.add_all_ordered_items_to_stripe_session(
					order.find_ordered_items_in_cart(
						maker_with_items.shop
					)
				).first[:price]
			).to eq(user_with_items.cart.items.first.stripe_price_id)
		end

		it 'total_price_for_new_order(ordered_cart_items) should return the price of each item * the qty' do
			expect(order.total_price_for_new_order(order.find_ordered_items_in_cart(maker_with_items.shop))).to eq(38)
		end
	end
end
