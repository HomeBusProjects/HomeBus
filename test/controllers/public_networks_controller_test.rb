require "test_helper"

class PublicNetworksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @public_network = public_networks(:one)
  end

  test "should get index" do
    get public_networks_url
    assert_response :success
  end

  test "should get new" do
    get new_public_network_url
    assert_response :success
  end

  test "should create public_network" do
    assert_difference('PublicNetwork.count') do
      post public_networks_url, params: { public_network: { active: @public_network.active, description: @public_network.description, network_id: @public_network.network_id, title: @public_network.title } }
    end

    assert_redirected_to public_network_url(PublicNetwork.last)
  end

  test "should show public_network" do
    get public_network_url(@public_network)
    assert_response :success
  end

  test "should get edit" do
    get edit_public_network_url(@public_network)
    assert_response :success
  end

  test "should update public_network" do
    patch public_network_url(@public_network), params: { public_network: { active: @public_network.active, description: @public_network.description, network_id: @public_network.network_id, title: @public_network.title } }
    assert_redirected_to public_network_url(@public_network)
  end

  test "should destroy public_network" do
    assert_difference('PublicNetwork.count', -1) do
      delete public_network_url(@public_network)
    end

    assert_redirected_to public_networks_url
  end
end
