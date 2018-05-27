require "application_system_test_case"

class DevicesTest < ApplicationSystemTestCase
  setup do
    @device = devices(:one)
  end

  test "visiting the index" do
    visit devices_url
    assert_selector "h1", text: "Devices"
  end

  test "creating a Device" do
    visit devices_url
    click_on "New Device"

    fill_in "Accuracy", with: @device.accuracy
    fill_in "Bridge", with: @device.bridge
    fill_in "Friendly Name", with: @device.friendly_name
    fill_in "Manufacturer", with: @device.manufacturer
    fill_in "Model Number", with: @device.model_number
    fill_in "Precision", with: @device.precision
    fill_in "Provision Request", with: @device.provision_request_id
    fill_in "Provisioned", with: @device.provisioned
    fill_in "Serial Number", with: @device.serial_number
    fill_in "Update Frequency", with: @device.update_frequency
    click_on "Create Device"

    assert_text "Device was successfully created"
    click_on "Back"
  end

  test "updating a Device" do
    visit devices_url
    click_on "Edit", match: :first

    fill_in "Accuracy", with: @device.accuracy
    fill_in "Bridge", with: @device.bridge
    fill_in "Friendly Name", with: @device.friendly_name
    fill_in "Manufacturer", with: @device.manufacturer
    fill_in "Model Number", with: @device.model_number
    fill_in "Precision", with: @device.precision
    fill_in "Provision Request", with: @device.provision_request_id
    fill_in "Provisioned", with: @device.provisioned
    fill_in "Serial Number", with: @device.serial_number
    fill_in "Update Frequency", with: @device.update_frequency
    click_on "Update Device"

    assert_text "Device was successfully updated"
    click_on "Back"
  end

  test "destroying a Device" do
    visit devices_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Device was successfully destroyed"
  end
end
