class CreateSpaces < ActiveRecord::Migration[5.2]
  def change
    create_table :spaces, id: :uuid do |t|
      t.string :friendly_name
      t.boolean :interior

      t.timestamps
    end
  end
end
