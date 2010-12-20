class RemoveCachedSlugFromPages < ActiveRecord::Migration
  def self.up
    remove_column :pages, :cached_slug
  end

  def self.down
    add_column :pages, :cached_slug, :string
  end
end
