class CreateNetwork < ActiveRecord::Migration[5.2]
  def change
    create_table :networks do |t|
      t.string :name, null: false, index: true
      t.integer :count_of_users, null: false, default: 0
      t.string :token, null: false, index: true
    end
  end
end
