class AddTokenToNetwork < ActiveRecord::Migration[5.2]
  def change
    add_column :networks, :token, :string, null: false, index: true
  end
end
