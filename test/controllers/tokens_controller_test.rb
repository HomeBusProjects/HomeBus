require 'test_helper'

class TokensControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @token = tokens(:one)

    @user_nonadmin = users(:user_nonadmin)
    @user_admin = users(:user_admin)

    @user_nonadmin.confirm
    @user_nonadmin.approve!

    @user_admin.confirm
    @user_admin.approve!
  end

  test 'should get index' do
    get tokens_url
    assert_redirected_to new_user_session_path
  end

  test 'should get new' do
    get new_token_url
    assert_redirected_to new_user_session_path
  end

  test 'should create token' do
    assert_difference('Token.count') do
      post tokens_url, params: { token: { enabled: @token.enabled } }
    end

    assert_redirected_to new_user_session_path
  end

  test 'should show token' do
    get token_url(@token)
    assert_redirected_to new_user_session_path
  end

  test 'should get edit' do
    get edit_token_url(@token)
    assert_redirected_to new_user_session_path
  end

  test 'should update token' do
    patch token_url(@token), params: { token: { enabled: @token.enabled } }
    assert_redirected_to new_user_session_path
  end

  test 'should destroy token' do
    delete token_url(@token)
    assert_redirected_to new_user_session_path
  end

if false
  test 'non-admin should get index' do
    get tokens_url
    assert_response :success
  end

  test 'non-admin should get new' do
    get new_token_url
r    assert_response :success
  end

  test 'non-admin should create token' do
    assert_difference('Token.count') do
      post tokens_url, params: { token: { enabled: @token.enabled } }
    end

    assert_redirected_to token_url(Token.last)
  end

  test 'non-admin should show token' do
    get token_url(@token)
    assert_response :success
  end

  test 'non-admin should get edit' do
    get edit_token_url(@token)
    assert_response :success
  end

  test 'non-admin should update token' do
    patch token_url(@token), params: { token: { enabled: @token.enabled } }
    assert_redirected_to token_url(@token)
  end

  test 'non-admin should destroy token' do
    assert_difference('Token.count', -1) do
      delete token_url(@token)
    end

    assert_redirected_to tokens_url
  end

end



  test 'admin should get index' do
    sign_in @user_admin

    get tokens_url
    assert_response :success

    sign_out @user_admin
  end

  test 'admin should get new' do
    sign_in @user_admin

    get new_token_url
    assert_response :success

    sign_out @user_admin
  end

  test 'admin should create token' do
    sign_in @user_admin

    assert_difference('Token.count') do
      post tokens_url, params: { token: { enabled: @token.enabled } }
    end

    assert_redirected_to token_url(Token.last)

    sign_out @user_admin
  end

  test 'admin should show token' do
    sign_in @user_admin

    get token_url(@token)
    assert_response :success

    sign_out @user_admin
  end

  test 'admin should get edit' do
    sign_in @user_admin

    get edit_token_url(@token)
    assert_response :success

    sign_out @user_admin
  end

  test 'admin should update token' do
    sign_in @user_admin

    patch token_url(@token), params: { token: { enabled: @token.enabled } }
    assert_redirected_to token_url(@token)

    sign_out @user_admin
  end

  test 'admin should destroy token' do
    sign_in @user_admin

    assert_difference('Token.count', -1) do
      delete token_url(@token)
    end

    assert_redirected_to tokens_url

    sign_out @user_admin
  end
end
