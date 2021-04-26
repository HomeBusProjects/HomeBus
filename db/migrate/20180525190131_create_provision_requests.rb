# frozen_string_literal: true

class CreateProvisionRequests < ActiveRecord::Migration[5.2]
  def change
    create_table :provision_requests, id: :uuid do |t|
      t.string :pin, null: false, default: ''
      t.inet :ip_address, null: false

      t.string :friendly_name, null: false, default: ''
      t.string :friendly_location, null: false, default: ''

      t.string :manufacturer, null: false, default: ''
      t.string :model, null: false, default: ''
      t.string :serial_number, null: false, default: ''

      t.integer :status, limit: 1

      t.timestamps

      t.index :friendly_name
      t.index :manufacturer
      t.index :model
    end
  end
end
