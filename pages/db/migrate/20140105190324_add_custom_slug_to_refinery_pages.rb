class AddCustomSlugToRefineryPages < ActiveRecord::Migration[4.2]
  def up
    if page_column_names.exclude?('custom_slug')
      add_column :refinery_pages, :custom_slug, :string
    end
  end

  def down
    if page_column_names.include?('custom_slug')
      remove_column :refinery_pages, :custom_slug
    end
  end

  private
  def page_column_names
    return [] unless defined?(::Refinery::Page)

    Refinery::Page.column_names.map(&:to_s)
  end
end
