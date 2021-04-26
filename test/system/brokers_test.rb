# frozen_string_literal: true

require 'application_system_test_case'

class BrokersTest < ApplicationSystemTestCase
  setup do
    @broker = brokers(:one)
  end

  test 'visiting the index' do
    visit brokers_url
    assert_selector 'h1', text: 'Brokers'
  end

  test 'creating a Broker' do
    visit brokers_url
    click_on 'New Broker'

    fill_in 'Auth token', with: @broker.auth_token
    fill_in 'Name', with: @broker.name
    click_on 'Create Broker'

    assert_text 'Broker was successfully created'
    click_on 'Back'
  end

  test 'updating a Broker' do
    visit brokers_url
    click_on 'Edit', match: :first

    fill_in 'Auth token', with: @broker.auth_token
    fill_in 'Name', with: @broker.name
    click_on 'Update Broker'

    assert_text 'Broker was successfully updated'
    click_on 'Back'
  end

  test 'destroying a Broker' do
    visit brokers_url
    page.accept_confirm do
      click_on 'Destroy', match: :first
    end

    assert_text 'Broker was successfully destroyed'
  end
end
