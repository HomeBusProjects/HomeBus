require "test_helper"

class DevicesNetworksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @devices_network = devices_networks(:one)
  end

  test "should get index" do
    get devices_networks_url
    assert_response :success
  end

  test "should get new" do
    get new_devices_network_url
    assert_response :success
  end

  test "should create devices_network" do
    assert_difference('DevicesNetwork.count') do
      post devices_networks_url, params: { devices_network: {  } }
    end

    assert_redirected_to devices_network_url(DevicesNetwork.last)
  end

  test "should show devices_network" do
    get devices_network_url(@devices_network)
    assert_response :success
  end

  test "should get edit" do
    get edit_devices_network_url(@devices_network)
    assert_response :success
  end

  test "should update devices_network" do
    patch devices_network_url(@devices_network), params: { devices_network: {  } }
    assert_redirected_to devices_network_url(@devices_network)
  end

  test "should destroy devices_network" do
    assert_difference('DevicesNetwork.count', -1) do
      delete devices_network_url(@devices_network)
    end

    assert_redirected_to devices_networks_url
  end
end
