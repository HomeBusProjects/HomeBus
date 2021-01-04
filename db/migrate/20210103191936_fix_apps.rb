class FixApps < ActiveRecord::Migration[6.1]
  def change
    change_column :apps, :name, :string, null: false, default: '', index: true
    change_column :apps, :source, :string, null: false, default: ''

    add_column :apps, :description, :string, null: false, default: '', index: true
    add_column :apps, :parameters, :string, null: false, default: ''
  end
end
