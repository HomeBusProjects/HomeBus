class CreateNetworkMonitors < ActiveRecord::Migration[6.1]
  def change
    create_table :network_monitors, id: :uuid, default: -> { "gen_random_uuid()" } do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.references :provision_request, null: false, foreign_key: true, type: :uuid
      t.datetime :last_accessed

      t.timestamps
    end

    add_index :network_monitors, :last_accessed
  end
end
