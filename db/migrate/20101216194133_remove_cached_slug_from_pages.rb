class RemoveCachedSlugFromPages < ActiveRecord::Migration
  def self.up
    if ::Page.column_names.map(&:to_s).include?('cached_slug')
      remove_column ::Page.table_name, :cached_slug
    end

    ::Page.reset_column_information
  end

  def self.down
    # Don't add this column back, it breaks stuff.
  end
end
