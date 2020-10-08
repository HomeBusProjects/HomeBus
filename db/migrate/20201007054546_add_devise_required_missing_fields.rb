class AddDeviseRequiredMissingFields < ActiveRecord::Migration[6.0]
  def up
    change_table(:users) do |t|
      ## Confirmable
      t.string   :confirmation_token, unique: true
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at
      t.string   :unconfirmed_email # Only if using reconfirmable

      User.update_all confirmed_at: DateTime.now

      ## Lockable
      t.integer  :failed_attempts, default: 0, null: false # Only if lock strategy is :failed_attempts
      t.string   :unlock_token # Only if unlock strategy is :email or :both
      t.datetime :locked_at
    end 

    add_index :users, :confirmation_token, unique: true
    add_index :users, :unlock_token, unique: true
  end

  def down
    remove_index :users, :confirmation_token
    remove_index :users, :unlock_token

    remove_columns :users, :confirmation_token, :confirmed_at, :confirmation_sent_at, :unconfirmed_email, :failed_attempts, :unlock_token, :locked_at
  end
end
