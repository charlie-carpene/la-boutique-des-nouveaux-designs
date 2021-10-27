require 'rails_helper'

RSpec.describe Order, type: :model do
  let!(:categories) { create_list(:category, 4) }
  let!(:maker_with_items) { maker_with_items_in_shop(items_count: 2, categories: categories) }
  let!(:user_with_items) { user_with_items_in_cart(items_count: 2, items: maker_with_items.shop.items) }
  let!(:item) { item_s_with_pictures(available_qty: 2, categories: [categories.sample], shop: maker_with_items.shop).first }
	let!(:cart_item) { create(:cart_item, cart: user_with_items.cart, item: item) }
	let!(:order) do
		o = create(:order, user: user_with_items)
		create(:order_item, price: item.price, order: o, item: item)
		return o
	end

	it 'should create a valid instance of Order' do
		expect(order).to be_valid
	end
end