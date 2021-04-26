# frozen_string_literal: true

class RenameDevicesAndSpacesToDevicesSpaces < ActiveRecord::Migration[5.2]
  def up
    rename_table :devices_and_spaces, :devices_spaces
  end

  def down
    rename_table :devices_spaces, :devices_and_spaces
  end
end
