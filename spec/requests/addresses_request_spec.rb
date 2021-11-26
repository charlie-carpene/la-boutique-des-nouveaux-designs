require 'rails_helper'

RSpec.describe "Address", type: :request do
  let!(:maker) { create(:user, :is_maker) }
  let!(:user) { create(:user) }
  let!(:address) { create(:address, user: user) }

  describe 'GET /users/:user_id/addresses/new (#new)' do
    it 'should work as user is signed in' do
      sign_in user
      get new_user_address_path(user.id)
      expect(response).to have_http_status(200)
    end

    it 'should fail when someone else tries to access the ressource' do
      get new_user_address_path(maker.id)
      expect(response).to have_http_status(302)
      expect(flash[:error]).to include(I18n.t("ability.errors.action_not_allowed"))
    end
  end

  describe 'POST /users/:user_id/addresses (#create)' do
    it 'should work as user is signed in' do
      sign_in user
      post user_addresses_path(user.id), params: { address: attributes_for(:address) }
      expect(response).to have_http_status(:see_other)
      expect(flash[:success]).to include(I18n.t("address.success.created"))
    end

    it 'should fail when someone else tries to access the ressource' do
      post user_addresses_path(user.id), params: { address: attributes_for(:address) }
      expect(response).to have_http_status(302)
      expect(flash[:error]).to include(I18n.t("ability.errors.action_not_allowed"))
    end
  end

  describe 'GET /users/:user_id/addresses/:id (#show)' do
    it 'should work when user is signed in' do
      get user_address_path(user.id, address.id)
      expect(response).to have_http_status(302)
      expect(flash[:error]).to include(I18n.t("ability.errors.action_not_allowed"))

      sign_in maker
      get user_address_path(user.id, address.id)
      expect(response).to have_http_status(302)
      expect(flash[:error]).to include(I18n.t("ability.errors.action_not_allowed"))

      sign_in user
      get user_address_path(user.id, address.id)
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /users/:user_id/addresses/:id (#edit)' do
    it 'should work as user is signed in' do
      get edit_user_address_path(user.id, address.id)
      expect(response).to have_http_status(302)
      expect(flash[:error]).to include(I18n.t("ability.errors.action_not_allowed"))

      sign_in maker
      get edit_user_address_path(user.id, address.id)
      expect(response).to have_http_status(302)
      expect(flash[:error]).to include(I18n.t("ability.errors.action_not_allowed"))

      sign_in user
      get edit_user_address_path(user.id, address.id)
      expect(response).to have_http_status(200)
    end
  end

  describe 'PUT /users/:user_id/address/:id (#update)' do
    it 'should work as user is signed in' do
      put user_address_path(user.id, address.id), params: { address: { city: 'Tatayoyo' }}
      expect(response).to have_http_status(302)
      expect(flash[:error]).to include(I18n.t("ability.errors.action_not_allowed"))

      sign_in maker
      put user_address_path(user.id, address.id), params: { address: { city: 'Tatayoyo' }}
      expect(response).to have_http_status(302)
      expect(flash[:error]).to include(I18n.t("ability.errors.action_not_allowed"))

      sign_in user
      put user_address_path(user.id, address.id), params: { address: { city: 'Tatayoyo' }}
      expect(response).to have_http_status(:see_other)
      expect(flash[:success]).to include(I18n.t("address.success.updated"))
    end
  end

  describe 'DELETE /users/:user_id/address/:id (#destroy)' do
    it 'should work as user is signed in' do
      delete user_address_path(user.id, address.id)
      expect(response).to have_http_status(302)
      expect(flash[:error]).to include(I18n.t("ability.errors.action_not_allowed"))

      sign_in maker
      delete user_address_path(user.id, address.id)
      expect(response).to have_http_status(302)
      expect(flash[:error]).to include(I18n.t("ability.errors.action_not_allowed"))

      sign_in user
      delete user_address_path(user.id, address.id)
      expect(response).to have_http_status(:see_other)
      expect(flash[:info]).to include(I18n.t("address.deleted"))
    end
  end
end
