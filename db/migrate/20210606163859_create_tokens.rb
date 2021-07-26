class CreateTokens < ActiveRecord::Migration[6.1]
  def change
    create_table :tokens, id: :string do |t|
      t.references :user, index: true, foreign_key: true
      t.references :device, index: true, foreign_key: true, null: true, type: :uuid
      t.references :provision_request, index: true, foreign_key: true, null: true, type: :uuid
      t.references :network, index: true, foreign_key: true, null: true

      t.string :name, null: false
      t.string :scope, null: false
      t.boolean :enabled, null: false, default: false

      t.datetime :expires, null: true

      t.timestamps
    end
  end
end
