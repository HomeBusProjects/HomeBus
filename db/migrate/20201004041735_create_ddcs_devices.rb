class CreateDdcsDevices < ActiveRecord::Migration[6.0]
  def change
    create_table :ddcs_devices do |t|
      t.references :device, type: :uuid
      t.references :ddc

      t.boolean :publishable, null: false, default: false
      t.boolean :consumable, null: false, default: false

      t.boolean :allow_publish, null: false, default: false
      t.boolean :allow_consume, null: false, default: false

      t.timestamps

      t.index [ :device_id, :publishable ]
      t.index [ :ddc_id, :publishable ]

      t.index [ :device_id, :consumable ]
      t.index [ :ddc_id, :consumable ]

      t.index [ :device_id, :allow_publish ]
      t.index [ :device_id, :allow_consume ]
    end
  end
end
