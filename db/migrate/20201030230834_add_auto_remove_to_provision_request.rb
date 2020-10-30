class AddAutoRemoveToProvisionRequest < ActiveRecord::Migration[6.0]
  def change
    add_column :provision_requests, :last_refresh, :datetime
    add_column :provision_requests, :autoremove_interval, :integer

    add_index :provision_requests, :autoremove_interval
    add_index :provision_requests, :last_refresh
  end
end
