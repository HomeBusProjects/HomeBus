class CreateDdcsDevices < ActiveRecord::Migration[6.0]
  def change
    create_table :ddcs_devices do |t|
      t.references :device, type: :uuid
      t.references :ddc

      t.boolean :enabled, null: false, default: true
      t.boolean :publishable, null: false, default: false
      t.boolean :consumable, null: false, default: false

      t.timestamps
    end
  end
end
