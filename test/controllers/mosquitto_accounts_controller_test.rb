require 'test_helper'

class MosquittoAccountsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @mosquitto_account = mosquitto_accounts(:one)
  end

  test "should get index" do
    get mosquitto_accounts_url
    assert_response :success
  end

  test "should get new" do
    get new_mosquitto_account_url
    assert_response :success
  end

  test "should create mosquitto_account" do
    assert_difference('MosquittoAccount.count') do
      post mosquitto_accounts_url, params: { mosquitto_account: { password: @mosquitto_account.password, provision_request_id: @mosquitto_account.provision_request_id, superuser: @mosquitto_account.superuser, username: @mosquitto_account.username } }
    end

    assert_redirected_to mosquitto_account_url(MosquittoAccount.last)
  end

  test "should show mosquitto_account" do
    get mosquitto_account_url(@mosquitto_account)
    assert_response :success
  end

  test "should get edit" do
    get edit_mosquitto_account_url(@mosquitto_account)
    assert_response :success
  end

  test "should update mosquitto_account" do
    patch mosquitto_account_url(@mosquitto_account), params: { mosquitto_account: { password: @mosquitto_account.password, provision_request_id: @mosquitto_account.provision_request_id, superuser: @mosquitto_account.superuser, username: @mosquitto_account.username } }
    assert_redirected_to mosquitto_account_url(@mosquitto_account)
  end

  test "should destroy mosquitto_account" do
    assert_difference('MosquittoAccount.count', -1) do
      delete mosquitto_account_url(@mosquitto_account)
    end

    assert_redirected_to mosquitto_accounts_url
  end
end
