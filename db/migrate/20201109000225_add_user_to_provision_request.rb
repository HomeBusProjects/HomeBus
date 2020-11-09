class AddUserToProvisionRequest < ActiveRecord::Migration[6.0]
  def change
    add_reference :provision_requests, :user, null: false, foreign_key: true
  end
end
