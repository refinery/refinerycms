class AddCustomSlug < ActiveRecord::Migration
  def up
    if ::Refinery::Page.column_names.map(&:to_sym).exclude?(:custom_slug)
      add_column ::Refinery::Page.table_name, :custom_slug, :string, :default => nil
    end
  end

  def down
    remove_column ::Refinery::Page.table_name, :custom_slug
  end
end
