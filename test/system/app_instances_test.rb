require "application_system_test_case"

class AppInstancesTest < ApplicationSystemTestCase
  setup do
    @app_instance = app_instances(:one)
  end

  test "visiting the index" do
    visit app_instances_url
    assert_selector "h1", text: "App Instances"
  end

  test "creating a App instance" do
    visit app_instances_url
    click_on "New App Instance"

    fill_in "App", with: @app_instance.app_id
    fill_in "Parameters", with: @app_instance.parameters
    fill_in "Public key", with: @app_instance.public_key
    fill_in "User", with: @app_instance.user_id
    click_on "Create App instance"

    assert_text "App instance was successfully created"
    click_on "Back"
  end

  test "updating a App instance" do
    visit app_instances_url
    click_on "Edit", match: :first

    fill_in "App", with: @app_instance.app_id
    fill_in "Parameters", with: @app_instance.parameters
    fill_in "Public key", with: @app_instance.public_key
    fill_in "User", with: @app_instance.user_id
    click_on "Update App instance"

    assert_text "App instance was successfully updated"
    click_on "Back"
  end

  test "destroying a App instance" do
    visit app_instances_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "App instance was successfully destroyed"
  end
end
