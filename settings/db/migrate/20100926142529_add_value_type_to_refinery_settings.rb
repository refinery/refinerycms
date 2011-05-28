class AddValueTypeToRefinerySettings < ActiveRecord::Migration
  def self.up
    add_column ::Refinery::Setting.table_name, :form_value_type, :string
  end

  def self.down
    remove_column ::Refinery::Setting.table_name, :form_value_type
  end
end
