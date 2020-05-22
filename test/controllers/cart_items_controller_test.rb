require 'test_helper'

class CartItemsControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get cart_items_create_url
    assert_response :success
  end

  test "should get update" do
    get cart_items_update_url
    assert_response :success
  end

  test "should get destroy" do
    get cart_items_destroy_url
    assert_response :success
  end

end
