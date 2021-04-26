# frozen_string_literal: true

class AddSiteAdminToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :site_admin, :boolean, null: false, default: false
  end
end
