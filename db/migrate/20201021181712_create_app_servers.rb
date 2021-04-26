# frozen_string_literal: true

class CreateAppServers < ActiveRecord::Migration[6.0]
  def change
    create_table :app_servers do |t|
      t.string :name
      t.integer :port
      t.string :secret_key

      t.timestamps
    end
  end
end
