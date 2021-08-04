class RenameDdcsProvisionRequest < ActiveRecord::Migration[6.1]
  def change
    rename_column :provision_requests, :wo_ddcs, :publishes
    rename_column :provision_requests, :ro_ddcs, :consumes
  end
end
