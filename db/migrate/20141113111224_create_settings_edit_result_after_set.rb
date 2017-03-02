class CreateSettingsEditResultAfterSet < ActiveRecord::Migration
  def self.up
    Setting.find_or_create_by(:name => 'Allow Result Edit After Set', :value => 'Disabled', :description => 'Once a result has been set, editing the result is blocked if this is disabled.')
  end

  def self.down
    Setting.find_by_name('Allow Result Edit After Set').destroy
  end
end
