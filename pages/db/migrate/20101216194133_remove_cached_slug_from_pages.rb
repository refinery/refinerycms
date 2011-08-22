class RemoveCachedSlugFromPages < ActiveRecord::Migration
  def self.up
    if ::Refinery::Page.column_names.map(&:to_s).include?('cached_slug')
      say_with_time("Removing cached_slug column from ::Refinery::Page table") do
        remove_column ::Refinery::Page.table_name, :cached_slug
      end
    else
      say "Nothing done, no cached_slug field found in ::Refinery::Page table"
    end

    ::Refinery::Page.reset_column_information
  end

  def self.down
    # Don't add this column back, it breaks stuff.
  end
end
