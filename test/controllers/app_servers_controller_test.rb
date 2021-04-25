require 'test_helper'

class AppServersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @app_server = app_servers(:one)
  end

if false
  test "should get index" do
    get app_servers_url
    assert_response :success
  end

  test "should get new" do
    get new_app_server_url
    assert_response :success
  end

  test "should create app_server" do
    assert_difference('AppServer.count') do
      post app_servers_url, params: { app_server: { name: @app_server.name, port: @app_server.port, secret_key: @app_server.secret_key } }
    end

    assert_redirected_to app_server_url(AppServer.last)
  end

  test "should show app_server" do
    get app_server_url(@app_server)
    assert_response :success
  end

  test "should get edit" do
    get edit_app_server_url(@app_server)
    assert_response :success
  end

  test "should update app_server" do
    patch app_server_url(@app_server), params: { app_server: { name: @app_server.name, port: @app_server.port, secret_key: @app_server.secret_key } }
    assert_redirected_to app_server_url(@app_server)
  end

  test "should destroy app_server" do
    assert_difference('AppServer.count', -1) do
      delete app_server_url(@app_server)
    end

    assert_redirected_to app_servers_url
  end
end
end
