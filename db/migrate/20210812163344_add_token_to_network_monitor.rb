class AddTokenToNetworkMonitor < ActiveRecord::Migration[6.1]
  def change
    add_reference :network_monitors, :token, null: false, foreign_key: true, type: :string
  end
end
