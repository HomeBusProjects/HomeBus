# frozen_string_literal: true

class DropSpacesTable < ActiveRecord::Migration[5.2]
  def change
    drop_table :spaces
    drop_table :devices_spaces
  end
end
