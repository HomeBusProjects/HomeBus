# frozen_string_literal: true

class CreateDevicesUsersJoinTable < ActiveRecord::Migration[6.0]
  def change
    create_table :devices_users, id: false do |t|
      t.integer :user_id, null: false
      t.uuid :device_id, null: false

      t.integer :user_role, null: false, default: 0

      t.timestamps

      t.index :device_id
      t.index :user_id
    end
  end
end
