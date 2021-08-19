class AddDdcsToApp < ActiveRecord::Migration[6.1]
  def change
    add_column :apps, :consumes, :string, array: true, null: false, default: []
    add_column :apps, :publishes, :string, array: true, null: false, default: []

    add_index :apps, :consumes, using: :gin
    add_index :apps, :publishes, using: :gin
  end
end
