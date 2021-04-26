# frozen_string_literal: true

class CreatePermissions < ActiveRecord::Migration[6.0]
  def change
    create_table :permissions do |t|
      t.belongs_to :device, null: false, foreign_key: true, type: :uuid
      t.belongs_to :network, null: false, foreign_key: true
      t.belongs_to :ddc, null: false, foreign_key: true

      t.boolean :consumes, null: false
      t.boolean :publishes, null: false

      t.timestamps

      t.index %i[device_id network_id ddc_id consumes], name: :index_permissions_consumable
      t.index %i[device_id network_id ddc_id publishes], name: :index_permissions_publishable
    end
  end
end
