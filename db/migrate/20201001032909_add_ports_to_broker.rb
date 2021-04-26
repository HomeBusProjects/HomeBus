# frozen_string_literal: true

class AddPortsToBroker < ActiveRecord::Migration[6.0]
  def change
    add_column :brokers, :secure_port, :integer, null: false, default: 1883
    add_column :brokers, :insecure_port, :integer, null: false, default: 8883
  end
end
