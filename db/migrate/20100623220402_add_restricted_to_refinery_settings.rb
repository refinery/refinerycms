class AddRestrictedToRefinerySettings < ActiveRecord::Migration
  def self.up
    add_column :refinery_settings, :restricted, :boolean, :default => false
  end

  def self.down
    remove_column :refinery_settings, :restricted
  end
end
