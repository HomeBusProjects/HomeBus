# frozen_string_literal: true

class AddDdcsToProvisionRequest < ActiveRecord::Migration[5.2]
  def change
    add_column :provision_requests, :ro_ddcs, :string, array: true, null: false, default: []
    add_column :provision_requests, :wo_ddcs, :string, array: true, null: false, default: []
    add_column :provision_requests, :rw_ddcs, :string, array: true, null: false, default: []
    add_column :provision_requests, :allocated_uuids, :uuid, array: true, null: false, default: []
    add_column :provision_requests, :requestsed_uuid_count, :integer, null: false, default: 1

    add_index :provision_requests, :ro_ddcs, using: 'gin'
    add_index :provision_requests, :wo_ddcs, using: 'gin'
    add_index :provision_requests, :rw_ddcs, using: 'gin'
    add_index :provision_requests, :allocated_uuids, using: 'gin'
  end
end
