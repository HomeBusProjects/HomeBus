class FixBrokerNetworkAssociation < ActiveRecord::Migration[5.2]
  def change
    remove_reference :brokers, :network, index: true
    add_reference :networks, :broker, index: true
  end
end
