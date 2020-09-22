class CreateNetworksUser < ActiveRecord::Migration[5.2]
  def change
    create_table :networks_users do |t|
      t.references :network
      t.references :user
    end
  end
end
