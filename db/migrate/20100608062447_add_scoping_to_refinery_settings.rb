class AddScopingToRefinerySettings < ActiveRecord::Migration
  def self.up
    add_column :refinery_settings, :scoping, :string, :default => nil
  end

  def self.down
    remove_column :refinery_settings, :scoping
  end
end
