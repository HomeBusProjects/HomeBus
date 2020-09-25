class FixProvisionRequestNetworkRelationship < ActiveRecord::Migration[5.2]
  def change
    drop_table :networks_provision_requests

    add_reference :provision_requests, :network
  end
end
