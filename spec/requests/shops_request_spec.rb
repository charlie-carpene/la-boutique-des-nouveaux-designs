require 'rails_helper'

RSpec.describe "Shops", type: :request do
  let!(:user) { create(:user) }
  let!(:maker) { create(:user, :is_maker, email: "gradya@yopmail.com") }

  context 'GET /shops/new' do
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
      post shops_path, :params => { shop: { 
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

  context 'GET /shops/:id' do
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
end
