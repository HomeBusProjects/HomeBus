class CreateBrokerAcl < ActiveRecord::Migration[6.1]
  def change
    create_table :broker_acls do |t|
      t.uuid :username, null: false
      t.string :topic, null: false
      t.belongs_to :provision_request, null: false, foreign_key: true, type: :uuid
      t.integer :permissions, null: false, default: 0

      t.index :username
      t.index :topic
      t.index :created_at

      t.timestamps
    end
  end
end
