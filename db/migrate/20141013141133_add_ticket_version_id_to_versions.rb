class AddTicketVersionIdToVersions < ActiveRecord::Migration
  def change
    add_column :versions, :ticket_version_id, :integer
  end

  def self.down
    remove_column :versions, :ticket_version_id
  end
end
