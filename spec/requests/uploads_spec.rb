require 'rails_helper'

RSpec.describe "Uploads", type: :request do
  describe "GET /image" do
    it "returns http success" do
      get "/uploads/image"
      expect(response).to have_http_status(:success)
    end
  end

end
