class AddValueTypeToRefinerySettings < ActiveRecord::Migration
  def self.up
    add_column :refinery_settings, :form_value_type, :string
  end

  def self.down
    remove_column :refinery_settings, :form_value_type
  end
end
