class AddSshToBroker < ActiveRecord::Migration[6.1]
  def change
    add_column :brokers, :ssh_hostname, :string
    add_column :brokers, :ssh_username, :string
    add_column :brokers, :ssh_key, :string
    add_column :brokers, :postgresql_database, :string
    add_column :brokers, :postgresql_username, :string
    add_column :brokers, :postgresql_password, :string
  end
end
