require 'test_helper'

class ProvisionRequestsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @provision_request = provision_requests(:one)
  end

  test "should get index" do
    get provision_requests_url
    assert_response :success
  end

  test "should get new" do
    get new_provision_request_url
    assert_response :success
  end

  test "should create provision_request" do
    assert_difference('ProvisionRequest.count') do
      post provision_requests_url, params: { provision_request: { ip_adress: @provision_request.ip_adress, pin: @provision_request.pin, ro_topics: @provision_request.ro_topics, status: @provision_request.status, wo_topics: @provision_request.wo_topics } }
    end

    assert_redirected_to provision_request_url(ProvisionRequest.last)
  end

  test "should show provision_request" do
    get provision_request_url(@provision_request)
    assert_response :success
  end

  test "should get edit" do
    get edit_provision_request_url(@provision_request)
    assert_response :success
  end

  test "should update provision_request" do
    patch provision_request_url(@provision_request), params: { provision_request: { ip_adress: @provision_request.ip_adress, pin: @provision_request.pin, ro_topics: @provision_request.ro_topics, status: @provision_request.status, wo_topics: @provision_request.wo_topics } }
    assert_redirected_to provision_request_url(@provision_request)
  end

  test "should destroy provision_request" do
    assert_difference('ProvisionRequest.count', -1) do
      delete provision_request_url(@provision_request)
    end

    assert_redirected_to provision_requests_url
  end
end
