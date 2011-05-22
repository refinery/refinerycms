class AddValueTypeToRefinerySettings < ActiveRecord::Migration
  def self.up
    add_column ::Refinery::RefinerySetting.table_name, :form_value_type, :string

    ::Refinery::RefinerySetting.reset_column_information
  end

  def self.down
    remove_column ::Refinery::RefinerySetting.table_name, :form_value_type

    ::Refinery::RefinerySetting.reset_column_information
  end
end
