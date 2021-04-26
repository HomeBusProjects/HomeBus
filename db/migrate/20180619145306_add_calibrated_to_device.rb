# frozen_string_literal: true

class AddCalibratedToDevice < ActiveRecord::Migration[5.2]
  def change
    add_column :devices, :calibrated, :boolean, null: false, default: false
  end
end
