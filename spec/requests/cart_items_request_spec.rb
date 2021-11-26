require 'rails_helper'

RSpec.describe "CartItem", type: :request do
  let!(:categories) { create_list(:category, 4) }
  let(:maker) { maker_with_items_in_shop(items_count: 2, available_qty: 2, categories: categories) }
  let(:user) { create(:user) }
  let!(:cart_item_params) {{ 
    cart_id: user.cart.id,
    item_id: maker.shop.items.first.id,
    item_qty_in_cart: 1,
  }}

  describe "POST /cart_items (#create)" do
    it "should work when 1. user is signed in, 2. item is available in enough qty 3. item is not in cart already" do
      sign_in user
      post cart_items_path(user.cart.id), params: cart_item_params
      expect(response).to have_http_status(302)
      expect(flash[:success]).to include(I18n.t("cart_item.success.item_added_to_cart"))
    end

    it "should fail when an other user than the cart owner tries the request" do
      sign_in maker
      post cart_items_path(user.cart.id), params: cart_item_params
      expect(response).to have_http_status(302)
      expect(flash[:error]).to include(I18n.t("ability.errors.action_not_allowed"))
    end

    it 'should fail if item is not available in qty enough' do
      sign_in user
      cart_item_params[:item_qty_in_cart] = 3
      post cart_items_path(user.cart.id), params: cart_item_params
      expect(response).to have_http_status(302)
      expect(flash[:error]).to include(I18n.t("cart_item.errors.item_qty_too_low"))
    end

    it 'should fail if item is already in cart' do
      sign_in user
      create(:cart_item, cart: user.cart, item: maker.shop.items.first)
      post cart_items_path(user.cart.id), params: cart_item_params
      expect(response).to have_http_status(302)
      expect(flash[:info]).to include(I18n.t("cart_item.info.item_already_in_cart"))
    end
  end

  describe "PUT /cart_items/:id (#update)" do
    let!(:cart_item) { create(:cart_item, cart: user.cart, item: maker.shop.items.first, item_qty_in_cart: 1) }

    it 'should work if 1. user is signed in, 2. operation params is correct' do
      sign_in user
      put cart_item_path(cart_item.id), params: { operation: 'plus' }
      expect(response).to have_http_status(200)

      put cart_item_path(cart_item.id), params: { operation: 'minus' }
      expect(response).to have_http_status(200)
    end

    it 'should fail when an other user than the cart owner tries the request' do
      put cart_item_path(cart_item.id), params: { operation: 'plus' }
      expect(response).to have_http_status(302)
      expect(flash[:error]).to include(I18n.t("ability.errors.action_not_allowed"))

      sign_in maker
      put cart_item_path(cart_item.id), params: { operation: 'minus' }
      expect(response).to have_http_status(302)
      expect(flash[:error]).to include(I18n.t("ability.errors.action_not_allowed"))
    end

    it 'should fail when operation doesnt exist' do 
      sign_in user
      put cart_item_path(cart_item.id), params: { operation: 'bad_operation_param' }
      expect(response).to have_http_status(302)
      expect(flash[:error]).to include(I18n.t("cart_item.errors.action_dont_exist"))
    end
  end

  describe 'DELETE /cart_item/:id (#destroy)' do
    let!(:cart_item) { create(:cart_item, cart: user.cart, item: maker.shop.items.first, item_qty_in_cart: 1) }

    it 'should work if user is signed in' do
      sign_in user
      delete cart_item_path(cart_item.id)
      expect(response).to have_http_status(200)
      expect(flash[:alert]).to include(I18n.t("cart_item.errors.item_deleted_from_cart", name: cart_item.item.name))
    end

    it 'should fail when an other user than the cart owner tries the request' do
      delete cart_item_path(cart_item.id)
      expect(response).to have_http_status(302)
      expect(flash[:error]).to include(I18n.t("ability.errors.action_not_allowed"))

      sign_in maker
      delete cart_item_path(cart_item.id)
      expect(response).to have_http_status(302)
      expect(flash[:error]).to include(I18n.t("ability.errors.action_not_allowed"))
    end
  end
end
