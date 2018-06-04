class ChangeProvisionRequestToUuidInMosquittoAcls < ActiveRecord::Migration[5.2]
  def change
    remove_column :mosquitto_acls, :provision_request_id
    add_column :mosquitto_acls, :provision_request_id, :uuid
    add_index :mosquitto_acls, :provision_request_id
  end
end
