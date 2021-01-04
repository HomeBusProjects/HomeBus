class FixBrokerPorts < ActiveRecord::Migration[6.1]
  def change
    add_column :brokers, :insecure_websocket_port, :integer, null: false, default: 9001
    add_column :brokers, :secure_websocket_port, :integer, null: false, default: 8083

    change_column :brokers, :insecure_port, :integer, null: false, default: 1883
    change_column :brokers, :secure_port, :integer, null: false, default: 8883
  end
end
