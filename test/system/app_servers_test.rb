# frozen_string_literal: true

require 'application_system_test_case'

class AppServersTest < ApplicationSystemTestCase
  setup do
    @app_server = app_servers(:one)
  end

  test 'visiting the index' do
    visit app_servers_url
    assert_selector 'h1', text: 'App Servers'
  end

  test 'creating a App server' do
    visit app_servers_url
    click_on 'New App Server'

    fill_in 'Name', with: @app_server.name
    fill_in 'Port', with: @app_server.port
    fill_in 'Secret key', with: @app_server.secret_key
    click_on 'Create App server'

    assert_text 'App server was successfully created'
    click_on 'Back'
  end

  test 'updating a App server' do
    visit app_servers_url
    click_on 'Edit', match: :first

    fill_in 'Name', with: @app_server.name
    fill_in 'Port', with: @app_server.port
    fill_in 'Secret key', with: @app_server.secret_key
    click_on 'Update App server'

    assert_text 'App server was successfully updated'
    click_on 'Back'
  end

  test 'destroying a App server' do
    visit app_servers_url
    page.accept_confirm do
      click_on 'Destroy', match: :first
    end

    assert_text 'App server was successfully destroyed'
  end
end
