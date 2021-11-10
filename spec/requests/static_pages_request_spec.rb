require 'rails_helper'

RSpec.describe "Static pages", type: :request do

  it 'GET / should work' do
    get root_path
    expect(response).to have_http_status(200)
  end

  context 'GET /stripe_fallback' do
    it 'should work' do
      get stripe_fallback_path, :params  => { status: "success" }
      expect(response).to have_http_status(200)
    end

    it 'should fail because params[status] are neither success nor cancel'  do
      get stripe_fallback_path, :params  => { status: "random_status" }
      expect(flash[:error]).to include(I18n.t("stripe.errors.fallback_status", status: request.params["status"]))
      expect(response).to have_http_status(302)
    end
  end
end