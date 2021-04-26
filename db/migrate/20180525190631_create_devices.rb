# frozen_string_literal: true

class CreateDevices < ActiveRecord::Migration[5.2]
  def change
    create_table :devices, id: :uuid do |t|
      t.boolean :provisioned, null: false, default: false

      t.string :friendly_name, null: false, default: ''
      t.string :friendly_location, null: false, default: ''

      t.integer :accuracy, null: false
      t.integer :precision, null: false
      t.integer :update_frequency, null: false

      t.string :wo_topics, array: true, default: []
      t.string :ro_topics, array: true, default: []
      t.string :rw_topics, array: true, default: []

      t.references :provision_request, foreign_key: true, index: true, type: :uuid
      t.integer :index, null: false, default: 0

      t.timestamps
    end
  end
end
