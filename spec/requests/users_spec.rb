require 'rails_helper'

RSpec.describe "Users", type: :request do
  let!(:user) { create(:user) }
  let!(:maker) { create(:user, :is_maker, email: "gradya@yopmail.com") }

  describe "GET /users/:id" do
    it "works because user is logged_in" do
      sign_in user
      get user_url(user.id)
      
      expect(response).to have_http_status(200)
      expect(flash[:error].present?).to be_falsey
    end

    it 'does not works because maker should not have access to user account' do
      sign_in maker
      get user_url(user.id)

      expect(response).to have_http_status(302)
      expect(flash[:error].present?).to be_truthy
    end
  end

  describe "GET /users/:id/edit" do
    it 'should fail as no user are sign in' do
      get edit_user_url(user.id)
      expect(response).to have_http_status(302)
      expect(flash[:error]).to include(I18n.t('errors.admin_required'))
    end

    it 'should fail as user is not admin and user has no shop' do
      sign_in user
      get edit_user_url(user.id)
      expect(response).to have_http_status(302)
      expect(flash[:error]).to include(I18n.t('errors.admin_required'))
    end

    it 'should pass as user is admin and maker has shop' do
      Admin.create(user: user)
      sign_in user
      get edit_user_url(maker.id)
      expect(response).to have_http_status(200)
    end
  end

  describe "PUT /users/:id/edit" do
    it 'should fail as user is not admin' do
      sign_in user
      put user_url(maker.id), :params => { user: { is_maker: true } }
      expect(response).to have_http_status(302)
      expect(request.flash[:error]).to include(I18n.t('error_500.body'))
    end

    it 'should pass as user is an admin' do
      Admin.create(user: user)
      sign_in user
      put user_url(maker.id), :params => { user: { is_maker: true } }
      expect(response).to have_http_status(302)
      expect(request.flash[:success]).to include(I18n.t("success.validate_user_as_maker", brand: maker.shop.brand, shop_email: maker.shop.email_pro))
    end
  end
end
