class AddPublicToDevice < ActiveRecord::Migration[6.1]
  def change
    add_column :devices, :public, :boolean, default: false, null: false

    add_index :devices, :public
  end
end
