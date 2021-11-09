require 'rails_helper'

RSpec.describe "Errors", type: :request do

  describe "GET /not_found" do
    it "returns http not_found" do
      get "/errors/not_found"
      expect(response).to have_http_status(:not_found)
      expect(response.body).to include(I18n.t("error_404.body"))
    end
  end

  describe "GET /internal_server_error" do
    it "returns http error" do
      get "/errors/internal_server_error"
      expect(response).to have_http_status(:error)
    end
  end

end
