require 'rails_helper'

RSpec.describe "Items", type: :request do
  let(:categories) { create_list(:category, 4) }
  let!(:maker) { maker_with_items_in_shop(items_count: 2, available_qty: 1, categories: categories) }
  let(:maker_2) { create(:user, :is_maker) }
  let!(:user) { user_with_items_in_cart(items: maker.shop.items) }
  let!(:uploaded_file) { Shrine.upload(File.open("#{Rails.root}/spec/fixtures/files/upload_img_test.png"), :cache) }

  context 'GET /items/new (#new)' do
    it 'should work when a maker is signed in' do
      sign_in maker
      get new_item_path
      expect(response).to have_http_status(200)
    end

    it 'should fail if no maker is signed in' do
      sign_in user
      get new_item_path
      expect(response).to have_http_status(302)
      expect(flash[:error]).to include(I18n.t("ability.errors.action_not_allowed"))
    end
  end

  context 'POST /items (#create)' do
    it 'should work when a maker is signed in' do 
      sign_in maker
      post items_path, params: { item: item_attr(maker.shop.id), files: [uploaded_file.to_json] }
      expect(response).to have_http_status(302)
      expect(flash[:success]).to include(I18n.t("item.success.created"))
    end

    it 'should fail because no makers are logged in' do
      sign_in user
      post items_path, params: { item: item_attr(maker.shop.id), files: [uploaded_file.to_json] }
      expect(response).to have_http_status(302)
      expect(flash[:error]).to include(I18n.t("ability.errors.action_not_allowed"))
    end
  end

  context 'GET /items/:id (#show)' do
    it 'should work' do
      get item_path(maker.shop.items.sample.id)
      expect(response).to have_http_status(200)
    end
  end

  context 'GET /items/:id/edit (#edit)' do    
    it 'should work when maker is signed in' do
      sign_in maker
      get edit_item_path(maker.shop.items.sample.id)
      expect(response).to have_http_status(200)
    end

    it 'should fail if someone else than the maker tries the request' do
      sign_in maker_2
      get edit_item_path(maker.shop.items.sample.id)
      expect(response).to have_http_status(302)
      expect(flash[:error]).to include(I18n.t("ability.errors.action_not_allowed"))
    end
  end

  context 'PUT /items/:id (#update)' do
    it 'should work when a maker update his item' do
      sign_in maker
      put item_path(maker.shop.items.last.id), params: { item: { name: "Hello world" } }
      expect(response).to have_http_status(302)
      expect(flash[:success]).to include(I18n.t("item.success.updated", item_name: "Hello world"))
    end

    it 'should work when item image is replaced' do
      sign_in maker
      put item_path(maker.shop.items.sample.id), params: { item: { name: "Hello world" }, files: [uploaded_file.to_json] }
      expect(response).to have_http_status(302)
      expect(flash[:success]).to include(I18n.t("item.success.updated", item_name: "Hello world"))
    end

    it 'should fail if someone else than the maker tries the request' do
      item = maker.shop.items.sample
      sign_in maker_2
      put item_path(item.id), params: { item: { name: "Hello world" } }

      expect(response).to have_http_status(302)
      expect(flash[:error]).to include(I18n.t("ability.errors.action_not_allowed"))
    end
  end

  context 'DELETE /items/:id (#destroy)' do
    it 'should work if item have not been bought yet and if items owner is logged in' do
      sign_in maker
      delete item_path(maker.shop.items.last)
      expect(response).to have_http_status(302)
      expect(flash[:error]).to include(I18n.t("item.errors.deleted"))
    end

    let!(:order) do
      o = create(:order, user: user)
      create(:order_item, price: maker.shop.items.first.price, order: o, item: maker.shop.items.first)
      return o
    end

    it 'should fail if item have been bought once already' do
      sign_in maker
      delete item_path(maker.shop.items.first)
      expect(response).to have_http_status(302)
      expect(flash[:error]).to include(I18n.t("item.errors.has_already_been_sold_once"))
    end

    it 'should fail if if someone else than the maker tries the request' do
      sign_in maker_2
      delete item_path(maker.shop.items.last)
      expect(response).to have_http_status(302)
      expect(flash[:error]).to include(I18n.t("ability.errors.action_not_allowed"))
    end
  end
end
