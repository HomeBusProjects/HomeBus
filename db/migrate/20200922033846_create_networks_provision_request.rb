# frozen_string_literal: true

class CreateNetworksProvisionRequest < ActiveRecord::Migration[5.2]
  def change
    create_table :networks_provision_requests do |t|
      t.references :network
      t.references :provision_request
    end
  end
end
