class FixAppServers < ActiveRecord::Migration[6.1]
  def change
    change_column :app_servers, :name, :string, null: false, index: true
    change_column :app_servers, :port, :string, null: false

    rename_column :app_servers, :secret_key, :public_key
    change_column :app_servers, :public_key, :string, null: false

    add_column :app_servers, :public, :boolean, null: false, default: false
    add_reference :app_servers, :owner, null: false, foreign_key: { to_table: :users }
  end
end
