# frozen_string_literal: true

require 'application_system_test_case'

class PublicDevicesTest < ApplicationSystemTestCase
  setup do
    @public_device = public_devices(:one)
  end

  test 'visiting the index' do
    visit public_devices_url
    assert_selector 'h1', text: 'Public Devices'
  end

  test 'creating a Public device' do
    visit public_devices_url
    click_on 'New Public Device'

    check 'Active' if @public_device.active
    fill_in 'Description', with: @public_device.description
    fill_in 'Device', with: @public_device.device_id
    fill_in 'Title', with: @public_device.title
    click_on 'Create Public device'

    assert_text 'Public device was successfully created'
    click_on 'Back'
  end

  test 'updating a Public device' do
    visit public_devices_url
    click_on 'Edit', match: :first

    check 'Active' if @public_device.active
    fill_in 'Description', with: @public_device.description
    fill_in 'Device', with: @public_device.device_id
    fill_in 'Title', with: @public_device.title
    click_on 'Update Public device'

    assert_text 'Public device was successfully updated'
    click_on 'Back'
  end

  test 'destroying a Public device' do
    visit public_devices_url
    page.accept_confirm do
      click_on 'Destroy', match: :first
    end

    assert_text 'Public device was successfully destroyed'
  end
end
