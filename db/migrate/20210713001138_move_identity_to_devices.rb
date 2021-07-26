class MoveIdentityToDevices < ActiveRecord::Migration[6.1]
  def change
    add_column :devices, :manufacturer, :string, null: false, default: ''
    add_column :devices, :model, :string, null: false, default: ''
    add_column :devices, :serial_number, :string, null: false, default: ''
    add_column :devices, :pin, :string, null: false, default: ''

    ProvisionRequest.find_each do |pr|
      pr.devices.find_each do |d|
        d.update(manufacturer: pr.manufacturer,
                 model: pr.model,
                 serial_number: pr.serial_number,
                 pin: pr.pin)
      end
    end

    remove_column :provision_requests, :manufacturer
    remove_column :provision_requests, :model
    remove_column :provision_requests, :serial_number
    remove_column :provision_requests, :pin
    remove_column :provision_requests, :allocated_uuids
    remove_column :provision_requests, :requested_uuid_count
  end
end
