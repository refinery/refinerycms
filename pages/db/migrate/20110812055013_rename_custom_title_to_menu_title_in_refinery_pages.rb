class RenameCustomTitleToMenuTitleInRefineryPages < ActiveRecord::Migration
  def up
    if ::Refinery::Page::Translation.column_names.map(&:to_sym).include?(:custom_title)
      rename_column ::Refinery::Page::Translation.table_name, :custom_title, :menu_title
    end
    remove_column ::Refinery::Page.table_name, :custom_title_type
  end

  def down
    if ::Refinery::Page::Translation.column_names.map(&:to_sym).include?(:menu_title)
      rename_column ::Refinery::Page::Translation.table_name, :menu_title, :custom_title
    end
    add_column ::Refinery::Page.table_name, :custom_title_type, :string
  end
end
