require "test_helper"

class PublicDevicesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @public_device = public_devices(:one)
  end

  test "should get index" do
    get public_devices_url
    assert_response :success
  end

  test "should get new" do
    get new_public_device_url
    assert_response :success
  end

  test "should create public_device" do
    assert_difference('PublicDevice.count') do
      post public_devices_url, params: { public_device: { active: @public_device.active, description: @public_device.description, device_id: @public_device.device_id, title: @public_device.title } }
    end

    assert_redirected_to public_device_url(PublicDevice.last)
  end

  test "should show public_device" do
    get public_device_url(@public_device)
    assert_response :success
  end

  test "should get edit" do
    get edit_public_device_url(@public_device)
    assert_response :success
  end

  test "should update public_device" do
    patch public_device_url(@public_device), params: { public_device: { active: @public_device.active, description: @public_device.description, device_id: @public_device.device_id, title: @public_device.title } }
    assert_redirected_to public_device_url(@public_device)
  end

  test "should destroy public_device" do
    assert_difference('PublicDevice.count', -1) do
      delete public_device_url(@public_device)
    end

    assert_redirected_to public_devices_url
  end
end
