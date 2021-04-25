require "test_helper"

class AppInstancesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @app_instance = app_instances(:one)
  end

if false
  test "should get index" do
    get app_instances_url
    assert_response :success
  end

  test "should get new" do
    get new_app_instance_url
    assert_response :success
  end

  test "should create app_instance" do
    assert_difference('AppInstance.count') do
      post app_instances_url, params: { app_instance: { app_id: @app_instance.app_id, parameters: @app_instance.parameters, public_key: @app_instance.public_key, user_id: @app_instance.user_id } }
    end

    assert_redirected_to app_instance_url(AppInstance.last)
  end

  test "should show app_instance" do
    get app_instance_url(@app_instance)
    assert_response :success
  end

  test "should get edit" do
    get edit_app_instance_url(@app_instance)
    assert_response :success
  end

  test "should update app_instance" do
    patch app_instance_url(@app_instance), params: { app_instance: { app_id: @app_instance.app_id, parameters: @app_instance.parameters, public_key: @app_instance.public_key, user_id: @app_instance.user_id } }
    assert_redirected_to app_instance_url(@app_instance)
  end

  test "should destroy app_instance" do
    assert_difference('AppInstance.count', -1) do
      delete app_instance_url(@app_instance)
    end

    assert_redirected_to app_instances_url
  end
end
end
