class CleanUpProvisionRequestsAndDevices < ActiveRecord::Migration[6.1]
  def change
    remove_column :devices, :calibrated

    remove_column :provision_requests, :rw_ddcs
  end
end
