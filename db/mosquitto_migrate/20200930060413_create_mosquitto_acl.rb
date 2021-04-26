# frozen_string_literal: true

class CreateMosquittoAcl < ActiveRecord::Migration[6.0]
  def change
    create_table :mosquitto_acls do |t|
      t.uuid :username, null: false
      t.string :topic, null: false
      t.uuid :provision_request_id, null: false
      t.integer :permissions, null: false, default: 0

      t.timestamps
    end

    add_index :mosquitto_acls, :username
    add_index :mosquitto_acls, :provision_request_id
    add_index :mosquitto_acls, :topic
  end
end
