class AddLocaleToSlugs < ActiveRecord::Migration
  def self.up
    add_column ::Slug.table_name, :locale, :string, :limit => 5

    add_index ::Slug.table_name, :locale

    ::Slug.reset_column_information
  end

  def self.down
    remove_column :slugs, :locale

    ::Slug.reset_column_information
  end
end
