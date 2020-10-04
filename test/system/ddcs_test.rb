require "application_system_test_case"

class DdcsTest < ApplicationSystemTestCase
  setup do
    @ddc = ddcs(:one)
  end

  test "visiting the index" do
    visit ddcs_url
    assert_selector "h1", text: "Ddcs"
  end

  test "creating a Ddc" do
    visit ddcs_url
    click_on "New Ddc"

    fill_in "Description", with: @ddc.description
    fill_in "Name", with: @ddc.name
    fill_in "Reference url", with: @ddc.reference_url
    click_on "Create Ddc"

    assert_text "Ddc was successfully created"
    click_on "Back"
  end

  test "updating a Ddc" do
    visit ddcs_url
    click_on "Edit", match: :first

    fill_in "Description", with: @ddc.description
    fill_in "Name", with: @ddc.name
    fill_in "Reference url", with: @ddc.reference_url
    click_on "Update Ddc"

    assert_text "Ddc was successfully updated"
    click_on "Back"
  end

  test "destroying a Ddc" do
    visit ddcs_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Ddc was successfully destroyed"
  end
end
