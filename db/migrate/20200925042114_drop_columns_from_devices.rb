# frozen_string_literal: true

class DropColumnsFromDevices < ActiveRecord::Migration[5.2]
  def change
    remove_column :devices, :friendly_location
    remove_column :devices, :accuracy
    remove_column :devices, :precision
    remove_column :devices, :provisioned
    remove_column :devices, :update_frequency
    remove_column :devices, :wo_topics
    remove_column :devices, :ro_topics
    remove_column :devices, :rw_topics
    remove_column :devices, :index
  end
end
