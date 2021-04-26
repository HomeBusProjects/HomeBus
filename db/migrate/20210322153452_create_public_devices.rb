# frozen_string_literal: true

class CreatePublicDevices < ActiveRecord::Migration[6.1]
  def change
    create_table :public_devices do |t|
      t.string :title
      t.string :description
      t.belongs_to :device, null: false, foreign_key: true, type: :uuid
      t.boolean :active

      t.timestamps
    end
  end
end
