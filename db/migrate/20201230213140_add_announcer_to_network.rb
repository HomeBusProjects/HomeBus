class AddAnnouncerToNetwork < ActiveRecord::Migration[6.1]
  def change
    add_reference :networks, :announcer, to_table: :devices, type: :uuid
  end
end
