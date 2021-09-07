require 'rails_helper'

RSpec.describe "Categories", type: :request do
  let!(:categories) { create_list(:category, 4) }

  describe "GET /categories" do
    it "works" do
      get "/categories/#{categories.sample.id}"
      expect(response).to have_http_status(200)
    end
  end
end
