# frozen_string_literal: true

class RemoveUsernameFromMosquittoAccount < ActiveRecord::Migration[5.2]
  def change
    remove_column :mosquitto_accounts, :username, :string
  end
end
