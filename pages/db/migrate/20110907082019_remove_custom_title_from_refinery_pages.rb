class RemoveCustomTitleFromRefineryPages < ActiveRecord::Migration
  def up
    if Refinery::Page.column_names.map(&:to_sym).include?(:custom_title)
      remove_column ::Refinery::Page.table_name, :custom_title

      Refinery::Page.reset_column_information
    end
  end

  def down
    add_column ::Refinery::Page.table_name, :custom_title, :string

    Refinery::Page.reset_column_information
  end
end
