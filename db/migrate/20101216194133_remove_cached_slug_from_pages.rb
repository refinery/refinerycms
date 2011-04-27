class RemoveCachedSlugFromPages < ActiveRecord::Migration
  def self.up
    if ::Page.column_names.map(&:to_s).include?('cached_slug')
      say_with_time("Removing cached_slug column from ::Page table") do
        remove_column ::Page.table_name, :cached_slug
      end
    else
      say "Nothing done, no cached_slug field found in ::Page table"
    end

    ::Page.reset_column_information
  end

  def self.down
    # Don't add this column back, it breaks stuff.
  end
end
