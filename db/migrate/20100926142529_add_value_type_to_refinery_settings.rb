class AddValueTypeToRefinerySettings < ActiveRecord::Migration
  def self.up
    add_column ::Refinery::Setting.table_name, :form_value_type, :string

    ::Refinery::Setting.reset_column_information
  end

  def self.down
    remove_column ::Refinery::Setting.table_name, :form_value_type

    ::Refinery::Setting.reset_column_information
  end
end
