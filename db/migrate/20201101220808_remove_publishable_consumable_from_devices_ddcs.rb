class RemovePublishableConsumableFromDevicesDdcs < ActiveRecord::Migration[6.0]
  def change
    remove_column :ddcs_devices, :publishable
    remove_column :ddcs_devices, :consumable
    remove_column :ddcs_devices, :allow_publish
    remove_column :ddcs_devices, :allow_consume
  end
end
