require "application_system_test_case"

class PublicNetworksTest < ApplicationSystemTestCase
  setup do
    @public_network = public_networks(:one)
  end

  test "visiting the index" do
    visit public_networks_url
    assert_selector "h1", text: "Public Networks"
  end

  test "creating a Public network" do
    visit public_networks_url
    click_on "New Public Network"

    check "Active" if @public_network.active
    fill_in "Description", with: @public_network.description
    fill_in "Network", with: @public_network.network_id
    fill_in "Title", with: @public_network.title
    click_on "Create Public network"

    assert_text "Public network was successfully created"
    click_on "Back"
  end

  test "updating a Public network" do
    visit public_networks_url
    click_on "Edit", match: :first

    check "Active" if @public_network.active
    fill_in "Description", with: @public_network.description
    fill_in "Network", with: @public_network.network_id
    fill_in "Title", with: @public_network.title
    click_on "Update Public network"

    assert_text "Public network was successfully updated"
    click_on "Back"
  end

  test "destroying a Public network" do
    visit public_networks_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Public network was successfully destroyed"
  end
end
