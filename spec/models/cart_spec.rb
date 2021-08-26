require 'rails_helper'

RSpec.describe Cart, type: :model do
  let(:categories) { create_list(:category, 4) }
  let(:maker_with_items) { maker_with_items_in_shop(items_count: 1, categories: categories) }
  let(:user_with_items) { user_with_items_in_cart(items_count: 1, item_qty_in_cart: 2, items: maker_with_items.shop.items) }

  it 'should create a valid instance of Cart' do
    expect(user_with_items.cart).to be_valid
    expect(maker_with_items.cart).to be_valid
  end

  context 'method' do
    it "get_items_shops should return an array of items' shops contained in the cart" do
      expect(user_with_items.cart.get_items_shops).to be_kind_of(Array)
      expect(user_with_items.cart.get_items_shops.first).to eq(maker_with_items.shop)
    end

    it 'get_cart_items_from_a_specific_shop(shop) should return an array of cart_items' do
      expect(user_with_items.cart.get_cart_items_from_a_specific_shop(maker_with_items.shop)).to be_kind_of(Array)
      expect(user_with_items.cart.get_cart_items_from_a_specific_shop(maker_with_items.shop).first).to eq(maker_with_items.shop.items.first.cart_items.first)
    end

    it 'get_total_price_from_a_specific_shop(shop) should return total price as an int' do
      expect(user_with_items.cart.get_total_price_from_a_specific_shop(maker_with_items.shop)).to be_kind_of(Integer)
      expect(user_with_items.cart.get_total_price_from_a_specific_shop(maker_with_items.shop)).to eq(38)
    end
  end
end
