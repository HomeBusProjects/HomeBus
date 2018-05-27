require "application_system_test_case"

class ProvisionRequestsTest < ApplicationSystemTestCase
  setup do
    @provision_request = provision_requests(:one)
  end

  test "visiting the index" do
    visit provision_requests_url
    assert_selector "h1", text: "Provision Requests"
  end

  test "creating a Provision request" do
    visit provision_requests_url
    click_on "New Provision Request"

    fill_in "Ip Adress", with: @provision_request.ip_adress
    fill_in "Pin", with: @provision_request.pin
    fill_in "Ro Topics", with: @provision_request.ro_topics
    fill_in "Status", with: @provision_request.status
    fill_in "Wo Topics", with: @provision_request.wo_topics
    click_on "Create Provision request"

    assert_text "Provision request was successfully created"
    click_on "Back"
  end

  test "updating a Provision request" do
    visit provision_requests_url
    click_on "Edit", match: :first

    fill_in "Ip Adress", with: @provision_request.ip_adress
    fill_in "Pin", with: @provision_request.pin
    fill_in "Ro Topics", with: @provision_request.ro_topics
    fill_in "Status", with: @provision_request.status
    fill_in "Wo Topics", with: @provision_request.wo_topics
    click_on "Update Provision request"

    assert_text "Provision request was successfully updated"
    click_on "Back"
  end

  test "destroying a Provision request" do
    visit provision_requests_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Provision request was successfully destroyed"
  end
end
