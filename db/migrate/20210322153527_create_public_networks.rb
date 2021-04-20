class CreatePublicNetworks < ActiveRecord::Migration[6.1]
  def change
    create_table :public_networks do |t|
      t.string :title
      t.string :description
      t.belongs_to :network, null: false, foreign_key: true
      t.boolean :active

      t.timestamps
    end
  end
end
