# frozen_string_literal: true

class DropTokenAndEntropyFromNetworks < ActiveRecord::Migration[5.2]
  def change
    remove_column :networks, :token
    remove_column :networks, :entropy
  end
end
