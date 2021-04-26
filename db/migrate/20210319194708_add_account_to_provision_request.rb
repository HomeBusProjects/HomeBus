# frozen_string_literal: true

class AddAccountToProvisionRequest < ActiveRecord::Migration[6.1]
  def change
    add_column :provision_requests, :account_id, :string
    add_column :provision_requests, :account_password, :string
    add_column :provision_requests, :account_encrypted_password, :string
  end
end
