class AddJsonToDdcs < ActiveRecord::Migration[6.0]
  def change
    add_column :ddcs, :json, :string, null: false, default: ''
    add_column :ddcs, :examples, :string, null: false, default: ''
  end
end
