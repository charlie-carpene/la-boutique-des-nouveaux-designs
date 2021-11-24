require 'rails_helper'

RSpec.describe "OrderItems", type: :request do
  let(:categories) { create_list(:category, 4) }
  let!(:maker) { maker_with_items_in_shop(items_count: 2, available_qty: 1, categories: categories) }
  let!(:user) { user_with_items_in_cart(items: maker.shop.items) }
  let!(:order) do
    o = create(:order, user: user)
    create(:order_item, price: maker.shop.items.first.price, order: o, item: maker.shop.items.first)
    return o
  end

  context 'GET /order_items (#index)' do
    it 'should work when user is signed in' do
      sign_in maker
      get order_items_path
      expect(response).to have_http_status(200)
    end

    it 'should not work if maker is not signed in' do
      sign_in user
      get order_items_path
      expect(response).to have_http_status(302)
      expect(flash[:error]).to include(I18n.t("ability.errors.action_not_allowed"))
    end
  end
end