class AddIssuesToAssignments < ActiveRecord::Migration
  def change
    add_column :assignments, :issues, :string
  end

  def self.down
    remove_column :assignments, :issues
  end
end
