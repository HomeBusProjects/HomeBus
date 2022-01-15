class CreateJournals < ActiveRecord::Migration[6.1]
  def change
    create_table :journals, id: :uuid do |t|
      t.string :req, null: false
      t.string :notes, null: false, default: ''
      t.jsonb :params, null: false, default: {}
      t.string :token

      t.timestamps
    end
  end
end
