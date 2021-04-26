# frozen_string_literal: true

class ChangeProvisionRequestToUuidInMosquittoAccounts < ActiveRecord::Migration[5.2]
  def change
    remove_column :mosquitto_accounts, :provision_request_id
    add_column :mosquitto_accounts, :provision_request_id, :uuid
    add_index :mosquitto_accounts, :provision_request_id
  end
end
