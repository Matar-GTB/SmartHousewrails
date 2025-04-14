require "test_helper"

class DeviceDataControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get device_data_create_url
    assert_response :success
  end

  test "should get destroy" do
    get device_data_destroy_url
    assert_response :success
  end
end
