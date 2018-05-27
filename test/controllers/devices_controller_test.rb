require 'test_helper'

class DevicesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @device = devices(:one)
  end

  test "should get index" do
    get devices_url
    assert_response :success
  end

  test "should get new" do
    get new_device_url
    assert_response :success
  end

  test "should create device" do
    assert_difference('Device.count') do
      post devices_url, params: { device: { accuracy: @device.accuracy, bridge: @device.bridge, friendly_name: @device.friendly_name, manufacturer: @device.manufacturer, model_number: @device.model_number, precision: @device.precision, provision_request_id: @device.provision_request_id, provisioned: @device.provisioned, serial_number: @device.serial_number, update_frequency: @device.update_frequency } }
    end

    assert_redirected_to device_url(Device.last)
  end

  test "should show device" do
    get device_url(@device)
    assert_response :success
  end

  test "should get edit" do
    get edit_device_url(@device)
    assert_response :success
  end

  test "should update device" do
    patch device_url(@device), params: { device: { accuracy: @device.accuracy, bridge: @device.bridge, friendly_name: @device.friendly_name, manufacturer: @device.manufacturer, model_number: @device.model_number, precision: @device.precision, provision_request_id: @device.provision_request_id, provisioned: @device.provisioned, serial_number: @device.serial_number, update_frequency: @device.update_frequency } }
    assert_redirected_to device_url(@device)
  end

  test "should destroy device" do
    assert_difference('Device.count', -1) do
      delete device_url(@device)
    end

    assert_redirected_to devices_url
  end
end
