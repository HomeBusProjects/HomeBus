# frozen_string_literal: true

require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:user_one)
    @user_nonadmin = users(:user_nonadmin)
    @user_admin = users(:user_admin)

    @user.confirm
    @user.approve!

    @user_nonadmin.confirm
    @user_nonadmin.approve!

    @user_admin.confirm
    @user_admin.approve!
  end

  # not logged in
  test 'should get index' do
    get users_url
    assert_redirected_to new_user_session_path
  end

  test 'should get new' do
    get new_user_url
    assert_redirected_to new_user_session_path
  end

  test 'should create user' do
    post users_url, params: { user: { email: @user.email, name: @user.name } }
    assert_redirected_to new_user_session_path
  end

  test 'should show user' do
    get user_url(@user)
    assert_redirected_to new_user_session_path
  end

  test 'should get edit' do
    get edit_user_url(@user)
    assert_redirected_to new_user_session_path
  end

  test 'should update user' do
    patch user_url(@user), params: { user: { email: @user.email, name: @user.name } }
    assert_redirected_to new_user_session_path
  end

  test 'should destroy user' do
    delete user_url(@user)
    assert_redirected_to new_user_session_path
  end

  if false
    test 'should get index' do
      get users_url
      assert_response :success
    end

    test 'should get new' do
      get new_user_url
      assert_response :success
    end

    test 'should create user' do
      assert_difference('User.count') do
        post users_url, params: { user: { email: @user.email, name: @user.name } }
      end

      assert_redirected_to user_url(User.last)
    end

    test 'should show user' do
      get user_url(@user)
      assert_response :success
    end

    test 'should get edit' do
      get edit_user_url(@user)
      assert_response :success
    end

    test 'should update user' do
      patch user_url(@user), params: { user: { email: @user.email, name: @user.name } }
      assert_redirected_to user_url(@user)
    end

    test 'should destroy user' do
      assert_difference('User.count', -1) do
        delete user_url(@user)
      end

      assert_redirected_to users_url
    end
  end

  test 'admin should get index' do
    sign_in @user_admin

    get users_url
    assert_response :success

    sign_out :user_admin
  end

  test 'admin should get new' do
    sign_in @user_admin

    get new_user_url
    assert_response :success

    sign_out :user_admin
  end

  test 'admin should create user' do
    sign_in @user_admin

    assert_difference('User.count') do
      post users_url,
           params: { user: { email: 'admin_created@example.com', name: 'A user has no name', password: 'open sesame' } }
    end

    assert_redirected_to user_url(User.last)

    sign_out :user_admin
  end

  test 'admin should show user' do
    sign_in @user_admin

    get user_url(@user)
    assert_response :success

    sign_out :user_admin
  end

  test 'admin should get edit' do
    sign_in @user_admin

    get edit_user_url(@user)
    assert_response :success

    sign_out :user_admin
  end

  test 'admin should update user' do
    sign_in @user_admin

    patch user_url(@user), params: { user: { email: @user.email, name: @user.name } }
    assert_redirected_to user_url(@user)

    sign_out :user_admin
  end

  test 'admin should destroy user' do
    sign_in @user_admin

    assert_difference('User.count', -1) do
      delete user_url(@user)
    end

    assert_redirected_to users_url

    sign_out :user_admin
  end
end
