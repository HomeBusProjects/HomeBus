class AddTimestampsToNetworks < ActiveRecord::Migration[6.1]
  def change
    add_column :networks, :created_at, :datetime, precision: 6, index: true
    add_column :networks, :updated_at, :datetime, precision: 6, index: true
  end
end
