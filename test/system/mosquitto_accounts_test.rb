require "application_system_test_case"

class MosquittoAccountsTest < ApplicationSystemTestCase
  setup do
    @mosquitto_account = mosquitto_accounts(:one)
  end

  test "visiting the index" do
    visit mosquitto_accounts_url
    assert_selector "h1", text: "Mosquitto Accounts"
  end

  test "creating a Mosquitto account" do
    visit mosquitto_accounts_url
    click_on "New Mosquitto Account"

    fill_in "Password", with: @mosquitto_account.password
    fill_in "Provision Request", with: @mosquitto_account.provision_request_id
    fill_in "Superuser", with: @mosquitto_account.superuser
    click_on "Create Mosquitto account"

    assert_text "Mosquitto account was successfully created"
    click_on "Back"
  end

  test "updating a Mosquitto account" do
    visit mosquitto_accounts_url
    click_on "Edit", match: :first

    fill_in "Password", with: @mosquitto_account.password
    fill_in "Provision Request", with: @mosquitto_account.provision_request_id
    fill_in "Superuser", with: @mosquitto_account.superuser
    click_on "Update Mosquitto account"

    assert_text "Mosquitto account was successfully updated"
    click_on "Back"
  end

  test "destroying a Mosquitto account" do
    visit mosquitto_accounts_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Mosquitto account was successfully destroyed"
  end
end
