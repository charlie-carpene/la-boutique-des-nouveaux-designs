require 'test_helper'

class ShopImagesControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get shop_images_show_url
    assert_response :success
  end

end
