require 'test_helper'

class DevicesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @device = devices(:one)
  end

if false
  test "should get index" do
    get devices_url
    assert_redirected_to new_user_session_url
#    assert_response :success
  end

  test "should get new" do
    get new_device_url
    assert_redirected_to new_user_session_url
#    assert_response :success
  end

  test "should create device" do
    assert_difference('Device.count', 0) do
#    assert_difference('Device.count') do
      post devices_url, params: { device: { accuracy: @device.accuracy, friendly_name: @device.friendly_name, friendly_location: @device.friendly_location, precision: @device.precision, provision_request_id: @device.provision_request_id, provisioned: @device.provisioned, update_frequency: @device.update_frequency, ro_topics: @device.ro_topics, wo_topics: @device.wo_topics, rw_topics: @device.rw_topics  } }
    end

    assert_redirected_to new_user_session_url
#    assert_redirected_to device_url(Device.last)
  end

  test "should show device" do
    get device_url(@device)
    assert_redirected_to new_user_session_url
#    assert_response :success
  end

  test "should get edit" do
    get edit_device_url(@device)
    assert_redirected_to new_user_session_url
#    assert_response :success
  end

  test "should update device" do
    patch device_url(@device), params: { device: { accuracy: @device.accuracy, friendly_name: @device.friendly_name, friendly_location: @device.friendly_location, precision: @device.precision, provision_request_id: @device.provision_request_id, provisioned: @device.provisioned, update_frequency: @device.update_frequency, ro_topics: @device.ro_topics, wo_topics: @device.wo_topics, rw_topics: @device.rw_topics  } }
    assert_redirected_to new_user_session_url
#    assert_redirected_to device_url(@device)
  end

  test "should destroy device" do
    assert_difference('Device.count', 0) do
#    assert_difference('Device.count', -1) do
      delete device_url(@device)
    end

    assert_redirected_to new_user_session_url
#    assert_redirected_to devices_url
  end
end
end
