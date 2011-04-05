class AddLocaleToSlugs < ActiveRecord::Migration
  def self.up
    add_column :slugs, :locale, :string, :limit => 5

    add_index :slugs, :locale

    ::Slug.reset_column_information
  end

  def self.down
    remove_column :slugs, :locale

    ::Slug.reset_column_information
  end
end
