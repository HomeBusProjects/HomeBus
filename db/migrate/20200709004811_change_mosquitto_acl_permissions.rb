# frozen_string_literal: true

class ChangeMosquittoAclPermissions < ActiveRecord::Migration[5.2]
  def change
    add_column :mosquitto_acls, :permissions, :integer, default: 7, null: false
    remove_column :mosquitto_acls, :rw
  end
end
