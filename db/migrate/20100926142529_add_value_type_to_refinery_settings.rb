class AddValueTypeToRefinerySettings < ActiveRecord::Migration
  def self.up
    add_column ::RefinerySetting.table_name, :form_value_type, :string

    ::RefinerySetting.reset_column_information
  end

  def self.down
    remove_column ::RefinerySetting.table_name, :form_value_type

    ::RefinerySetting.reset_column_information
  end
end
