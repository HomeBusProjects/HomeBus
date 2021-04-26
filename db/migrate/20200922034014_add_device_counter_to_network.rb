# frozen_string_literal: true

class AddDeviceCounterToNetwork < ActiveRecord::Migration[5.2]
  def change
    add_column :networks, :device_counter, :integer, default: 0, null: false
  end
end
