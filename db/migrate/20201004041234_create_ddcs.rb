class CreateDdcs < ActiveRecord::Migration[6.0]
  def change
    create_table :ddcs do |t|
      t.string :name, null: false, index: true
      t.string :description, null: false
      t.string :reference_url, null: false

      t.timestamps
    end
  end
end
