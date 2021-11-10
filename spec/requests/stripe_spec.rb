require 'rails_helper'

RSpec.describe "Stripes", type: :request do

  describe "GET /connect" do
    it "redirect to root because no token" do
      get "/stripe/connect"
      expect(response).to have_http_status(:found)
      expect(request.flash['error']).to include("le jeton d'identification n'a pas été trouvé")
    end

    it "redirect to root because tokens don't match" do
      get "/stripe/connect", params: { 'state' => "randomToken" }
      expect(response).to have_http_status(302)
      expect(request.flash['error']).to include("le jeton d'identification n'a pas été reconnu")
    end

    it "passes check_authenticity_token before_action" do
      pending ("waiting for more knowledge to develop it")
    end
  end
end
