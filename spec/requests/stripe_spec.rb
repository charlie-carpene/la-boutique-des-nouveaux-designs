require 'rails_helper'

RSpec.describe "Stripes", type: :request do
  describe "GET /connect" do
    it "returns http success" do
      get "/stripe/connect"
      expect(response).to have_http_status(:success)
    end
  end

end
