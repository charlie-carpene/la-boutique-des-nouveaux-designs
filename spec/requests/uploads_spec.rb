require 'rails_helper'

RSpec.describe "Uploads", type: :request do
  let!(:maker) { create(:user, :is_maker, email: "gradya@yopmail.com") }
  let!(:uploaded_file) { ActionDispatch::Http::UploadedFile.new({
    :filename => 'upload_img_test.png',
    :type => 'image/png',
    :tempfile => File.open("#{Rails.root}/spec/fixtures/files/upload_img_test.png")
  }) }
  
  describe "POST /images/upload" do
    it "returns http success" do
      sign_in maker

      post "/images/upload", :params => { 
        uploader_type: 'image',
        name: uploaded_file.original_filename, 
        type: uploaded_file.content_type, 
        file: uploaded_file
      }
      expect(response).to have_http_status(:success)
    end
  end

end
