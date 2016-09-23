class AddTicketProjectIdToProducts < ActiveRecord::Migration
  def change
    add_column :products, :ticket_project_id, :string
  end

  def self.down
    remove_column :products, :ticket_project_id
  end
end
