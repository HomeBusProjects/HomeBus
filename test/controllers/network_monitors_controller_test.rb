require "test_helper"

class NetworkMonitorsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @network_monitor = network_monitors(:one)
  end

  test "should get index" do
    get network_monitors_url
    assert_response :success
  end

  test "should get new" do
    get new_network_monitor_url
    assert_response :success
  end

  test "should create network_monitor" do
    assert_difference('NetworkMonitor.count') do
      post network_monitors_url, params: { network_monitor: { last_accessed: @network_monitor.last_accessed, provision_request: @network_monitor.provision_request, user_id: @network_monitor.user_id } }
    end

    assert_redirected_to network_monitor_url(NetworkMonitor.last)
  end

  test "should show network_monitor" do
    get network_monitor_url(@network_monitor)
    assert_response :success
  end

  test "should get edit" do
    get edit_network_monitor_url(@network_monitor)
    assert_response :success
  end

  test "should update network_monitor" do
    patch network_monitor_url(@network_monitor), params: { network_monitor: { last_accessed: @network_monitor.last_accessed, provision_request: @network_monitor.provision_request, user_id: @network_monitor.user_id } }
    assert_redirected_to network_monitor_url(@network_monitor)
  end

  test "should destroy network_monitor" do
    assert_difference('NetworkMonitor.count', -1) do
      delete network_monitor_url(@network_monitor)
    end

    assert_redirected_to network_monitors_url
  end
end
