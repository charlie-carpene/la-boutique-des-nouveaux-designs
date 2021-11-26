require 'rails_helper'

RSpec.describe "Cart", type: :request do
  let(:maker) { create(:user, :is_maker) }
  let(:user) { create(:user) }

  describe "GET /carts/:id (#show)" do
    it "should work when user is signed in" do
      sign_in user
      get cart_path(user.cart.id)
      expect(response).to have_http_status(200)
    end

    it "should fail when someone else than the cart owner tries to access" do
      sign_in maker
      get cart_path(user.cart.id)
      expect(response).to have_http_status(302)
      expect(flash[:error]).to include(I18n.t("ability.errors.action_not_allowed"))
    end
  end
end
