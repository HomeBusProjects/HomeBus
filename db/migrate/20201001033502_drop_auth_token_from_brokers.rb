class DropAuthTokenFromBrokers < ActiveRecord::Migration[6.0]
  def change
    remove_column :brokers, :auth_token
  end
end
