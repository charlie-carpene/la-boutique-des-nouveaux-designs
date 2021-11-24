require 'rails_helper'

RSpec.describe "Shops", type: :request do
  let!(:user) { create(:user) }
  let!(:maker) { create(:user, :is_maker, email: "gradya@yopmail.com") }

  context 'GET /shops/new (#new)' do
    it 'should redirect to sign_in if no user is loggedin' do
      get new_shop_path
      expect(response).to have_http_status(302)
      expect(flash[:alert]).to include(I18n.t("shop.errors.connect_to_become_maker"))
    end

    it 'should work when user is loggedin' do
      sign_in user
      get new_shop_path
      expect(response).to have_http_status(200)
    end
  end

  context 'GET /shops (#create)' do
    it 'should not work if user is not loggedin' do
      post shops_path
      expect(response).to have_http_status(302)
      expect(flash[:error]).to be_truthy
    end

    it 'shoud not work if user is already a maker' do
      sign_in maker
      post shops_path
      expect(response).to have_http_status(302)
      expect(flash[:error]).to include(I18n.t("shop.errors.already_exist"))
    end

    it 'should work if user is loggedin' do
      sign_in user
      @shop = FactoryBot.build(:shop)
      post shops_path, params: { shop: { 
        brand: @shop.brand,
        website: @shop.website,
        email_pro: @shop.email_pro,
        rich_description: @shop.rich_description,
        company_id: @shop.company_id,
        terms_of_service: @shop.terms_of_service
      }}
      expect(response).to have_http_status(302)
      expect(flash[:success]).to include(I18n.t("shop.success.shop_created"))
    end
  end

  context 'GET /shops/:id (#show)' do
    it 'should work for anyone' do
      get shop_url(maker.shop.id)
      expect(response).to have_http_status(200)
    end

    it 'should display edit button if user is maker' do
      sign_in maker
      get shop_url(maker.shop.id)
      expect(response).to have_http_status(200)
      expect(response.body).to include(I18n.t("button.see.shop_info"))
    end
  end

  context 'GET /shops/:id/edit (#edit)' do
    it 'should work when maker is signed_in' do
      sign_in maker
      get edit_shop_url(maker.shop.id)
      expect(response).to have_http_status(200)
    end

    it 'should not work if the shop does not belong to the associated user' do
      sign_in user
      get edit_shop_url(maker.shop.id)
      expect(response).to have_http_status(302)
      expect(flash[:error]).to include(I18n.t("ability.errors.action_not_allowed"))
    end
  end

  context 'POST /shops/:id (#update)' do
    it 'should work when the shop owner (maker) make a valid request' do
      sign_in maker
      put shop_path(maker.shop.id), params: { shop: {
        brand: "New Brand Name",
      }}
      expect(response).to have_http_status(302)
      expect(flash[:success]).to include(I18n.t("shop.success.shop_updated"))
    end

    it 'should not work if someone else than the maker tries to send the request' do
      put shop_path(maker.shop.id), params: { shop: {
        brand: "New Brand Name",
      }}
      expect(response).to have_http_status(302)
      expect(flash[:error]).to include(I18n.t("ability.errors.action_not_allowed"))
    end

    it 'should not work if the wrong param is sent' do
      sign_in maker
      expect{ put shop_path(maker.shop.id), :params => { test: { brand: "New Brand Name" }} }.to raise_error(ActionController::ParameterMissing)
    end
  end

  context 'DELETE /shops/:id (#destroy)' do
    it 'should destroy the shop if associated maker makes the request' do
      sign_in maker
      delete shop_url(maker.shop.id)
      expect(response).to have_http_status(302)
      expect(flash[:success]).to include(I18n.t("shop.success.shop_destroyed", brand: maker.shop.brand, email: maker.shop.email_pro))
    end

    it 'should not work if user does not have the rights' do
      sign_in user
      delete shop_url(maker.shop.id)
      expect(response).to have_http_status(302)
      expect(flash[:error]).to include(I18n.t("ability.errors.action_not_allowed"))
    end

    let(:admin) { create(:admin, user: user) }
    it 'should destroy the shop if an admin request it' do
      admin.user
      sign_in user
      delete shop_url(maker.shop.id)
      expect(response).to have_http_status(302)
      expect(flash[:success]).to include(I18n.t("shop.success.shop_destroyed", brand: maker.shop.brand, email: maker.shop.email_pro))
    end
  end
end
