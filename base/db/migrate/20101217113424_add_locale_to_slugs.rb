class AddLocaleToSlugs < ActiveRecord::Migration
  def self.up
    add_column ::Slug.table_name, :locale, :string

    add_index ::Slug.table_name, :locale
  end

  def self.down
    remove_column ::Slug.table_name, :locale

    remove_index ::Slug.table_name, :locale
  end
end
