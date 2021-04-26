# frozen_string_literal: true

class AddEnabledToMosquittoAccount < ActiveRecord::Migration[5.2]
  def change
    add_column :mosquitto_accounts, :enabled, :boolean, default: true, null: false
  end
end
