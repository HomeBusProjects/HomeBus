class DropFriendlyLocationFromProvisionRequests < ActiveRecord::Migration[5.2]
  def change
    remove_column :provision_requests, :friendly_location
  end
end
