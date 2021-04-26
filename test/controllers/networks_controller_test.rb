require 'test_helper'

class NetworksControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @network = networks(:one)

    @user_nonadmin = users(:user_nonadmin)
    @user_admin = users(:user_admin)

    @user_nonadmin.confirm
    @user_nonadmin.approve!

    @user_admin.confirm
    @user_admin.approve!
  end

  test "should get index" do
    get networks_url
    assert_redirected_to new_user_session_path
  end

  test "should get new" do
    get new_network_url
    assert_redirected_to new_user_session_path
  end

  test "should create network" do
    assert_difference('Network.count', 0) do
      post networks_url, params: { network: { name: 'Untitled network name' } }
    end

    assert_redirected_to new_user_session_path
  end

  test "should show network" do
    get network_url(@network)
    assert_redirected_to new_user_session_path
  end

  test "should get edit" do
    get edit_network_url(@network)
    assert_redirected_to new_user_session_path
  end

  test "should update network" do
    patch network_url(@network), params: { network: { count_of_users: @network.count_of_users, name: @network.name } }
    assert_redirected_to new_user_session_path
  end

  test "should destroy network" do
    assert_difference('Network.count', 0) do
      delete network_url(@network)
    end

    assert_redirected_to new_user_session_path
  end


if false
  test "should get index" do
    get networks_url
    assert_response :success
  end

  test "should get new" do
    get new_network_url
    assert_response :success
  end

  test "should create network" do
    assert_difference('Network.count') do
      post networks_url, params: { network: { count_of_users: @network.count_of_users, name: 'Untitled network name' } }
    end

    assert_redirected_to network_url(Network.last)
  end

  test "should show network" do
    get network_url(@network)
    assert_response :success
  end

  test "should get edit" do
    get edit_network_url(@network)
    assert_response :success
  end

  test "should update network" do
    patch network_url(@network), params: { network: { count_of_users: @network.count_of_users, name: @network.name } }
    assert_redirected_to network_url(@network)
  end

  test "should destroy network" do
    assert_difference('Network.count', -1) do
      delete network_url(@network)
    end

    assert_redirected_to networks_url
  end
end

  test "admin should get index" do
    sign_in @user_admin

    get networks_url
    assert_response :success

    sign_out @user_admin
  end

  test "admin should get new" do
    sign_in @user_admin

    get new_network_url
    assert_response :success

    sign_out @user_admin
  end

  test "admin should create network" do
    sign_in @user_admin

    assert_difference('Network.count') do
      post networks_url, params: { network: { count_of_users: @network.count_of_users, name: 'Untitled network name' } }
    end

    assert_redirected_to network_url(Network.last)

    sign_out @user_admin
  end

  test "admin should show network" do
    sign_in @user_admin

    get network_url(@network)
    assert_response :success

    sign_out @user_admin
  end

  test "admin should get edit" do
    sign_in @user_admin

    get edit_network_url(@network)
    assert_response :success

    sign_out @user_admin
  end

#  test "admin should update network" do
#    sign_in @user_admin
#
#    patch network_url(@network), params: { network: { count_of_users: @network.count_of_users, name: 'PATCHED Network name' } }
#    assert_redirected_to network_url(@network)
#
#    sign_out @user_admin
#  end

  test "admin should destroy network" do
    sign_in @user_admin

    assert_difference('Network.count', -1) do
      delete network_url(@network)
    end

    assert_redirected_to networks_url

    sign_out @user_admin
  end
end
