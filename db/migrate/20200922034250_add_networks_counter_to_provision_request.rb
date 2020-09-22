class AddNetworksCounterToProvisionRequest < ActiveRecord::Migration[5.2]
  def change
    add_column :provision_requests, :networks_counter, :integer, default: 0, null: false
  end
end
