require 'rails_helper'
require './spec/support/stripe_helpers.rb'

RSpec.describe "Orders", type: :request do
  let(:categories) { create_list(:category, 4) }
  let!(:maker) { maker_with_items_in_shop(items_count: 2, available_qty: 1, categories: categories) }
  let!(:user) { user_with_items_in_cart(items: maker.shop.items) }
  let!(:address) { create(:address, user: user) }

  context 'GET /orders/new (#new)' do    
    it 'should work when items in cart are still available in enough qty when purchased' do
      sign_in user
      get new_order_path, params: { shop_id: maker.shop.id }
      expect(response).to have_http_status(200)
    end

    describe 'when user want to order more than available qty' do
      let!(:maker_2) { maker_with_items_in_shop(items_count: 1, available_qty: 1, categories: categories) }
      let!(:user_2) { user_with_items_in_cart(item_qty_in_cart: 2, items: maker_2.shop.items) }

      it 'should not work' do
        sign_in user_2
        get new_order_path, params: { shop_id: maker_2.shop.id }
        expect(response).to have_http_status(302)
        expect(flash[:error]).to be_truthy
      end
    end

    describe 'when item is not available anymore' do
      let!(:maker_2) { maker_with_items_in_shop(items_count: 1, available_qty: 0, categories: categories) }
      let!(:user_2) { user_with_items_in_cart(item_qty_in_cart: 2, items: maker_2.shop.items) }
  
      it 'should not work' do
        sign_in user_2
        get new_order_path, params: { shop_id: maker_2.shop.id }
        expect(response).to have_http_status(302)
        expect(flash[:error]).to include(I18n.t("order.errors.item_no_longer_available", item_name: maker_2.shop.items.first.name))
      end
    end
  end

  context 'POST /orders (#create)' do
    before { StripeMock.start }
    after { StripeMock.stop }

    it 'should work' do
      user.delivery_address = user.addresses.first.id
      user.save

      sign_in user
      payload = {
        "id": "evt_test_webhook",
        "type": "checkout.session.completed",
        "data": {
          "object": {
            "metadata": {
              "customer": user.id,
              "shop": maker.shop.id,
              "address": user.delivery_address,
            }
          }
        }
      }
  
      headers = { "Stripe-Signature" => StripeData.generate_stripe_event_signature(payload.to_json) }
      post orders_path, params: payload, headers: headers, as: :json
      expect(response).to have_http_status(200)
    end
  end

  context 'GET /users/:user_id/orders/:order_id (#show)' do
    let!(:order) do
      o = create(:order, user: user)
      create(:order_item, price: maker.shop.items.first.price, order: o, item: maker.shop.items.first)
      return o
    end
  
    it 'should work when user is signed in' do
      sign_in user
      get user_order_path(user.id, order.id)
      expect(response).to have_http_status(200)
    end
  end

  context 'GET /users/:user_id/orders (#index)' do
    it 'should work when user is signed in' do
      sign_in user
      get user_orders_path(user.id)
      expect(response).to have_http_status(200)
    end
  end
end
