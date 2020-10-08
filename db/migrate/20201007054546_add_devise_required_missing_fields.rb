class AddDeviseRequiredMissingFields < ActiveRecord::Migration[6.0]
  def change
    ## Confirmable
    add_column :users, :confirmation_token, unique: true
    add_column :users, :confirmed_at
    add_column :users, :confirmation_sent_at
    add_column :users, :unconfirmed_email # Only if using reconfirmable

    add_index :users, :confirmation_token, unique: true

    User.update_all confirmed_at: DateTime.now

    # lockable
    add_column :users, :failed_attempts, default: 0, null: false # Only if lock strategy is :failed_attempts
    add_column :users, :unlock_token # Only if unlock strategy is :email or :both
    add_column :users, :locked_at

    add_index :users, :unlock_token, unique: true
  end
end
