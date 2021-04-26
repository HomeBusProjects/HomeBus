# frozen_string_literal: true

class CreateBrokers < ActiveRecord::Migration[5.2]
  def change
    create_table :brokers do |t|
      t.string :name, null: false
      t.string :auth_token, null: false

      t.integer :networks_count, null: false, default: 0
      t.integer :devices_count, null: false, default: 0

      t.timestamps

      t.index :name, unique: true
    end

    add_reference :brokers, :network, index: true
  end
end
