class CreateBrokerAccounts < ActiveRecord::Migration[6.1]
  def change
    create_table :broker_accounts, id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
      t.string :password, null: false
      t.string :enc_password, null: false
      t.boolean :superuser, null: false, default: false
      t.boolean :enabled, null: false, default: false
      t.belongs_to :provision_request, null: false, foreign_key: true, type: :uuid
      t.belongs_to :broker, null: false, foreign_key: true

      t.index :enabled
      t.index :created_at

      t.timestamps
    end
  end
end
