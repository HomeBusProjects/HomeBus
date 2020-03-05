require 'test_helper'

class MosquittoAclsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @mosquitto_acl = mosquitto_acls(:one)
  end

  test "should get index" do
    get mosquitto_acls_url
    assert_redirected_to new_user_session_url
#    assert_response :success
  end

  test "should get new" do
    get new_mosquitto_acl_url
    assert_redirected_to new_user_session_url
#    assert_response :success
  end

  test "should create mosquitto_acl" do
    assert_difference('MosquittoAcl.count') do
      post mosquitto_acls_url, params: { mosquitto_acl: { provision_request: @mosquitto_acl.provision_request, rw: @mosquitto_acl.rw, topic: @mosquitto_acl.topic, username: @mosquitto_acl.username } }
    end

    assert_redirected_to new_user_session_url
#    assert_redirected_to mosquitto_acl_url(MosquittoAcl.last)
  end

  test "should show mosquitto_acl" do
    get mosquitto_acl_url(@mosquitto_acl)
    assert_redirected_to new_user_session_url
#    assert_response :success
  end

  test "should get edit" do
    get edit_mosquitto_acl_url(@mosquitto_acl)
    assert_redirected_to new_user_session_url
#    assert_response :success
  end

  test "should update mosquitto_acl" do
    patch mosquitto_acl_url(@mosquitto_acl), params: { mosquitto_acl: { provision_request: @mosquitto_acl.provision_request, rw: @mosquitto_acl.rw, topic: @mosquitto_acl.topic, username: @mosquitto_acl.username } }
    assert_redirected_to new_user_session_url
#    assert_redirected_to mosquitto_acl_url(@mosquitto_acl)
  end

  test "should destroy mosquitto_acl" do
    assert_difference('MosquittoAcl.count', -1) do
      delete mosquitto_acl_url(@mosquitto_acl)
    end

    assert_redirected_to new_user_session_url
#    assert_redirected_to mosquitto_acls_url
  end
end
