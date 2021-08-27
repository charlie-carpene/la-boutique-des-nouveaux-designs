require 'rails_helper'

RSpec.describe CartItem, type: :model do
  let(:categories) { create_list(:category, 4) }
  let(:maker_with_items) { maker_with_items_in_shop(items_count: 2, available_qty: 2, categories: categories) }
  let(:user_with_items) { user_with_items_in_cart(items_count: 1, item_qty_in_cart: 1, items: maker_with_items.shop.items) }

  it 'should create a valid instance of Cart' do
    expect(user_with_items.cart.cart_items.first).to be_valid
  end

  context 'method' do
    it 'add_qty_if_available_enough should update item_qty_in_cart and return boolean' do
      expect(user_with_items.cart.cart_items.first.add_qty_if_available_enough).to be_truthy
      expect(user_with_items.cart.cart_items.first.add_qty_if_available_enough).to be_falsey
    end

    it 'remove_qty should update item_qty_in_cart by -1 and return boolean' do
      expect(user_with_items.cart.cart_items.first.remove_qty).to be_falsey

      user_with_items.cart.cart_items.first.add_qty_if_available_enough
      expect{ user_with_items.cart.cart_items.first.remove_qty }.to change{ user_with_items.cart.cart_items.first.item_qty_in_cart }.by(-1)
    end

    it 'total_price should return item price * qty_in_cart' do
      expect(user_with_items.cart.cart_items.first.total_price).to eq(19)

      user_with_items.cart.cart_items.first.add_qty_if_available_enough
      expect(user_with_items.cart.cart_items.first.total_price).to eq(38)
    end
  end
end
