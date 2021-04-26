# frozen_string_literal: true

class CreateMosquittoAccounts < ActiveRecord::Migration[5.2]
  def change
    create_table :mosquitto_accounts, id: :uuid do |t|
      t.string :username, null: false
      t.string :password, null: false
      t.boolean :superuser, null: false
      t.references :provision_request, index: true

      t.timestamps

      t.index :username
    end
  end
end
