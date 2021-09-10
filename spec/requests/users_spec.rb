require 'rails_helper'

RSpec.describe "Users", type: :request do
  let!(:user_1) { create(:user) }
  let!(:user_2) { create(:user, email: "gradya@yopmail.com") }

  describe "GET /users/:id" do
    it "works because user_1 is logged_in" do
      sign_in user_1
      get user_url(user_1.id)
      
      expect(response).to have_http_status(200)
      expect(flash[:error].present?).to be_falsey
    end

    it 'does not works because user_2 should not have access to user_1 account' do
      sign_in user_2
      get user_url(user_1.id)

      expect(response).to have_http_status(302)
      expect(flash[:error].present?).to be_truthy
    end
  end
end
