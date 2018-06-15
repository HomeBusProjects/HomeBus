class ChangeIndexToStringInDevices < ActiveRecord::Migration[5.2]
  def change
    change_column :devices, :index, :string
  end
end
