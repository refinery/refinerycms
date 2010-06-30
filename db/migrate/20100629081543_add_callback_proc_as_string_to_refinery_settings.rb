class AddCallbackProcAsStringToRefinerySettings < ActiveRecord::Migration
  def self.up
    add_column :refinery_settings, :callback_proc_as_string, :string
  end

  def self.down
    remove_column :refinery_settings, :callback_proc_as_string
  end
end
