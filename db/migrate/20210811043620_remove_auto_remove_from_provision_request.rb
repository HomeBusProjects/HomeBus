class RemoveAutoRemoveFromProvisionRequest < ActiveRecord::Migration[6.1]
  def change
    remove_column :provision_requests, :autoremove_interval, :integer
    remove_column :provision_requests, :autoremove_at, :datetime
    remove_column :provision_requests, :last_refresh, :datetime
  end
end
