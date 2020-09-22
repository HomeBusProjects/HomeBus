class AddNetworksCountToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :networks_count, :integer, default: 0, null: false
  end
end
