require "application_system_test_case"

class DevicesNetworksTest < ApplicationSystemTestCase
  setup do
    @devices_network = devices_networks(:one)
  end

  test "visiting the index" do
    visit devices_networks_url
    assert_selector "h1", text: "Devices Networks"
  end

  test "creating a Devices network" do
    visit devices_networks_url
    click_on "New Devices Network"

    click_on "Create Devices network"

    assert_text "Devices network was successfully created"
    click_on "Back"
  end

  test "updating a Devices network" do
    visit devices_networks_url
    click_on "Edit", match: :first

    click_on "Update Devices network"

    assert_text "Devices network was successfully updated"
    click_on "Back"
  end

  test "destroying a Devices network" do
    visit devices_networks_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Devices network was successfully destroyed"
  end
end
