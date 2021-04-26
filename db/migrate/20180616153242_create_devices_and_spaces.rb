# frozen_string_literal: true

class CreateDevicesAndSpaces < ActiveRecord::Migration[5.2]
  def change
    create_table :devices_and_spaces, id: false do |t|
      t.belongs_to :device, index: true, type: :uuid
      t.belongs_to :space, index: true, type: :uuid
    end
  end
end
