# frozen_string_literal: true

class AddEntropyToNetwork < ActiveRecord::Migration[5.2]
  def change
    add_column :networks, :entropy, :string, null: false
  end
end
