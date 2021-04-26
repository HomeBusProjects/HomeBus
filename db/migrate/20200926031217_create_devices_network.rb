# frozen_string_literal: true

class CreateDevicesNetwork < ActiveRecord::Migration[5.2]
  def change
    create_table :devices_networks do |t|
      t.references :network
      t.references :device, type: :uuid
    end
  end
end
