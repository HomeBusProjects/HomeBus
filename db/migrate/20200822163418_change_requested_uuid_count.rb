# frozen_string_literal: true

class ChangeRequestedUuidCount < ActiveRecord::Migration[5.2]
  def change
    rename_column :provision_requests, :requestsed_uuid_count, :requested_uuid_count
  end
end
