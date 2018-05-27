class CreateMosquittoAcls < ActiveRecord::Migration[5.2]
  def change
    create_table :mosquitto_acls do |t|
      t.string :username, null: false
      t.string :topic, null: false
      t.boolean :rw, null: false
      t.references :provision_request, index: true

      t.timestamps

      t.index :username
    end
  end
end
