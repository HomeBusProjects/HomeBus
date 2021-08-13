require "application_system_test_case"

class NetworkMonitorsTest < ApplicationSystemTestCase
  setup do
    @network_monitor = network_monitors(:one)
  end

  test "visiting the index" do
    visit network_monitors_url
    assert_selector "h1", text: "Network Monitors"
  end

  test "creating a Network monitor" do
    visit network_monitors_url
    click_on "New Network Monitor"

    fill_in "Last accessed", with: @network_monitor.last_accessed
    fill_in "Provision request", with: @network_monitor.provision_request
    fill_in "User", with: @network_monitor.user_id
    click_on "Create Network monitor"

    assert_text "Network monitor was successfully created"
    click_on "Back"
  end

  test "updating a Network monitor" do
    visit network_monitors_url
    click_on "Edit", match: :first

    fill_in "Last accessed", with: @network_monitor.last_accessed
    fill_in "Provision request", with: @network_monitor.provision_request
    fill_in "User", with: @network_monitor.user_id
    click_on "Update Network monitor"

    assert_text "Network monitor was successfully updated"
    click_on "Back"
  end

  test "destroying a Network monitor" do
    visit network_monitors_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Network monitor was successfully destroyed"
  end
end
