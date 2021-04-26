# frozen_string_literal: true

class DropMosquittoTables < ActiveRecord::Migration[6.0]
  def up
    drop_table :mosquitto_accounts
    drop_table :mosquitto_acls
  end
end
