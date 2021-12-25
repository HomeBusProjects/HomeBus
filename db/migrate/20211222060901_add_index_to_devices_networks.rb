class AddIndexToDevicesNetworks < ActiveRecord::Migration[6.1]
  def change
    add_index :devices_networks, [:device_id, :network_id], unique: true
  end
end
