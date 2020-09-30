class CreateMosquittoAccount < ActiveRecord::Migration[6.0]
  def change
    create_table :mosquitto_accounts id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
      t.string :password, null: false
      t.boolean :superuser, null: false, default: false
      t.uuid :provision_request_id, null: false
      t.boolean :enabled, null: false, default: true

      t.timestamps
    end

    add_index :mosquitto_accounts, :provision_request_id, unique: true
    add_index :mosquitto_accounts, [:enabled, :provision_request_id], unique: true
    add_index :mosquitto_accounts, [:id, :enabled]
    add_index :mosquitto_accounts, :created_at
  end
end
