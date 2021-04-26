# frozen_string_literal: true

class AddReadyToProvisionRequest < ActiveRecord::Migration[6.1]
  def change
    add_column :provision_requests, :ready, :boolean, default: true, null: false
    add_index :provision_requests, :ready
  end
end
