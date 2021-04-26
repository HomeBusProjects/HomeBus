# frozen_string_literal: true

class AddAautoremoveAtToProvisionRequest < ActiveRecord::Migration[6.1]
  def change
    add_column :provision_requests, :autoremove_at, :datetime
    add_index :provision_requests, :autoremove_at
  end
end
