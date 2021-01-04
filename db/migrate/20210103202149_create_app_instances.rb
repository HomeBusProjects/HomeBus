class CreateAppInstances < ActiveRecord::Migration[6.1]
  def change
    create_table :app_instances do |t|
      t.string :name, null: false, index: true

      t.references :app, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.json :parameters, null: false, default: '{}'
      t.string :public_key, null: false

      t.string :log, null: false, default: ''
      t.integer :interval, null: false, default: 60
      t.datetime :last_run, null: false, index: true

      t.timestamps
    end
  end
end
