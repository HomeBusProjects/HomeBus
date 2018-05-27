require "application_system_test_case"

class MosquittoAclsTest < ApplicationSystemTestCase
  setup do
    @mosquitto_acl = mosquitto_acls(:one)
  end

  test "visiting the index" do
    visit mosquitto_acls_url
    assert_selector "h1", text: "Mosquitto Acls"
  end

  test "creating a Mosquitto acl" do
    visit mosquitto_acls_url
    click_on "New Mosquitto Acl"

    fill_in "Provision Request", with: @mosquitto_acl.provision_request
    fill_in "Rw", with: @mosquitto_acl.rw
    fill_in "Topic", with: @mosquitto_acl.topic
    fill_in "Username", with: @mosquitto_acl.username
    click_on "Create Mosquitto acl"

    assert_text "Mosquitto acl was successfully created"
    click_on "Back"
  end

  test "updating a Mosquitto acl" do
    visit mosquitto_acls_url
    click_on "Edit", match: :first

    fill_in "Provision Request", with: @mosquitto_acl.provision_request
    fill_in "Rw", with: @mosquitto_acl.rw
    fill_in "Topic", with: @mosquitto_acl.topic
    fill_in "Username", with: @mosquitto_acl.username
    click_on "Update Mosquitto acl"

    assert_text "Mosquitto acl was successfully updated"
    click_on "Back"
  end

  test "destroying a Mosquitto acl" do
    visit mosquitto_acls_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Mosquitto acl was successfully destroyed"
  end
end
