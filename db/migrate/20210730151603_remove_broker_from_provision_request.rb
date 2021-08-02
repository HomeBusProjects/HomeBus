class RemoveBrokerFromProvisionRequest < ActiveRecord::Migration[6.1]
  def change
    remove_column :provision_requests, :account_id, :string
    remove_column :provision_requests, :account_password, :string
    remove_column :provision_requests, :account_encrypted_password, :string
  end
end
